const repository = require("./repository/userRepository");
const crypto = require("crypto");
const jwt = require("./jwt");

exports.register = async (req, res) => {
  console.log(req.body);
  const { id, password } = req.body;
  let { count } = await repository.findByLoginId(id);
  console.log(count);
  if (count > 0) {
    return res.send({ result: "fail", message: "중복된 아이디가존재합니다." });
  }
  const result = await crypto.pbkdf2Sync(
    password,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );
  const { affectedRows, insertId } = await repository.register(
    id,
    result.toString("base64")
  );
  if (affectedRows > 0) {
    const data = await jwt({ id: insertId });
    res.send({ result: "ok", access_token: data });
  } else {
    res.send({ result: "fail", message: "알 수 없는 오류" });
  }
};

exports.login = async (req, res) => {
  console.log(req.body);
  const { id, password } = req.body;
  const result = await crypto.pbkdf2Sync(
    password,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );
  const item = await repository.login(id, result.toString("base64"));
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
