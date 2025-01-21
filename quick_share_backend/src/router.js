const express = require("express");
const router = express.Router();

const webController = require("./web/webController");
const apiFeedController = require("./api/feed/feedController");
const apiUserController = require("./api/user/userController");
const { logRequestTime } = require("./middleware/log");
const fileController = require("./api/file/fileController");

const MemoController = require("../src/api/memo/memoController");

const auth = require("./middleware/auth");
const multer = require("multer");
const upload = multer({ dest: "storage/" });

router.use(logRequestTime);

// router.get("/", webController.home);

// router.get("/page/:route", webController.page);
// router.get("/page/:route", logRequestTime, webController.page);

// router.post("/file", upload.single("file"), fileController.upload);
// router.get("/file/:id", fileController.download);

router.post("/auth/register", apiUserController.register);
router.post("/auth/login", apiUserController.login);

router.get("/api/feed", auth, apiFeedController.index);
// router.post("/api/feed", auth, apiFeedController.store);
// router.get("/api/feed/:id", auth, apiFeedController.show);
// router.put("/api/feed/:id", auth, apiFeedController.update);
// router.delete("/api/feed/:id", auth, apiFeedController.delete);

// Memo 관련 API 엔드포인트
router.post("/api/memo", auth, MemoController.createMemo); // 메모 생성
router.get("/api/memo", auth, MemoController.getAllMemos); // 모든 메모 조회
router.get("/api/memo/:id", auth, MemoController.getMemoById); // 특정 메모 조회
router.put("/api/memo/:id", auth, MemoController.updateMemo); // 메모 수정
router.put("/api/memo/:id/share", auth, MemoController.shareMemo); // 메모 공유
router.delete("/api/memo/:id", auth, MemoController.deleteMemo); // 메모 삭제

router.post("/file", upload.single("file"), (req, res) => {
  console.log(req.file);
  res.json(req.file);
});
// 중략
module.exports = router;
