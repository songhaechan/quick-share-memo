const generateToken = require("./jwt");

exports.phone = (req, res) => {
  const now = new Date();
  now.setMinutes(now.getMinutes() + 3);
  const expiredTime = now.toISOString().replace("T", " ").substring(0, 19);
  res.json({ result: "ok", expired: expiredTime });
};
exports.phoneVerify = (req, res) => {
  const { code } = req.body;
  if (code == "1234") {
    res.json({ result: "ok", message: "성공" });
    return;
  }
  res.json({ result: "fail", message: "인증번호가 맞지않습니다." });
};

// exports.register = async (req, res) => {
//   // 사용자 정보 검증 로직이 들어갈 위치
//   try {
//     const userInfo = { id: 1, name: "홍길동" }; // 가정된 사용자 정보
//     const token = await generateToken(userInfo);
//     res.json({ result: "ok", access_token: token });
//   } catch (error) {
//     console.log(error);
//     res.status(500).json({
//       result: "error",
//       message: "토큰 발급실패",
//     });
//   }
// };

const repository = require("./repository/userRepository");
const crypto = require("crypto");
const jwt = require("./jwt");

exports.register = async (req, res) => {
  console.log(req.body);
  const { phone, password, name } = req.body;
  let { count } = await repository.findByPhone(phone);
  if (count > 0) {
    return res.send({ result: "fail", message: "중복된 번호가존재합니다." });
  }
  const result = await crypto.pbkdf2Sync(
    password,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );
  const { affectedRows, insertId } = await repository.register(
    phone,
    result.toString("base64"),
    name
  );
  if (affectedRows > 0) {
    const data = await jwt({ id: insertId, name });
    res.send({ result: "ok", access_token: data });
  } else {
    res.send({ result: "fail", message: "알 수 없는 오류" });
  }
};

exports.login = async (req, res) => {
  const { phone, password } = req.body;
  const result = await crypto.pbkdf2Sync(
    password,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );
  const item = await repository.login(phone, result.toString("base64"));
  if (item == null) {
    res.send({
      result: "fail",
      message: "휴대폰 번호 혹은비밀번호를 확인해 주세요",
    });
  } else {
    const data = await jwt({ id: item.id, name: item.name });
    res.send({ result: "ok", access_token: data });
  }
};
exports.show = async (req, res) => {
  const user = req.user; // 미들웨어에서 추가된 사용자 정보
  // 데이터베이스에서 사용자 정보 조회
  const item = await repository.findId(user.id);
  // 사용자 정보가 없을 경우
  if (item == null) {
    res.send({ result: "fail", message: "회원을 찾을 수없습니다." });
  } else {
    // 사용자 정보가 있을 경우
    res.send({ result: "ok", data: item });
  }
};
exports.update = async (req, res) => {
  const { name, profile_id } = req.body;
  const user = req.user;
  const result = await repository.update(user.id, name, profile_id);
  if (result.affectedRows > 0) {
    const item = await repository.findId(user.id);
    res.send({ result: "ok", data: item });
  } else {
    res.send({ result: "fail", message: "오류가 발생하였습니다." });
  }
};
