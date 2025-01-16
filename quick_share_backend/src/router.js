const express = require("express");
const router = express.Router();

const webController = require("./web/webController");
const apiFeedController = require("./api/feed/feedController");
const apiUserController = require("./api/user/userController");
const { logRequestTime } = require("./middleware/log");
const fileController = require("./api/file/fileController");
const auth = require("./middleware/auth");
const multer = require("multer");
const upload = multer({ dest: "storage/" });

router.use(logRequestTime);

router.get("/", webController.home);

router.get("/page/:route", webController.page);
// router.get("/page/:route", logRequestTime, webController.page);

router.post("/file", upload.single("file"), fileController.upload);
router.get("/file/:id", fileController.download);

router.post("/auth/phone", apiUserController.phone);
router.put("/auth/phone", apiUserController.phoneVerify);

router.post("/auth/register", apiUserController.register);
router.post("/auth/login", apiUserController.login);

router.get("/api/user/my", auth, apiUserController.show);
router.post("/api/user/my", auth, apiUserController.update);

router.get("/api/feed", auth, apiFeedController.index);
router.post("/api/feed", auth, apiFeedController.store);
router.get("/api/feed/:id", auth, apiFeedController.show);
router.put("/api/feed/:id", auth, apiFeedController.update);
router.delete("/api/feed/:id", auth, apiFeedController.delete);

router.post("/file", upload.single("file"), (req, res) => {
  console.log(req.file);
  res.json(req.file);
});
// 중략
module.exports = router;
