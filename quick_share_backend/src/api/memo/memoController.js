const MemoRepository = require("../memo/repository/memoRepository"); // MemoRepository import

class MemoController {
  // Memo 생성
  async createMemo(req, res) {
    console.log(req.body); // req.body를 찍어서 전달되는 값 확인
    const { title, content, createdAt } = req.body;
    const userId = req.user.id;
    const result = await MemoRepository.createMemo(
      title,
      content,
      createdAt,
      userId
    );
    if (result.affectedRows > 0) {
      res.send({ result: "ok", data: result.insertId });
    } else {
      res.send({ result: "fail", message: "오류가 발생하였습니다." });
    }
  }

  // Memo 조회 (모든 메모)
  async getAllMemos(req, res) {
    const userId = req.user.id;
    try {
      const memos = await MemoRepository.getAllMemos(userId);
      res.send({
        message: "Memos retrieved successfully",
        data: memos,
      });
    } catch (error) {
      res.status(500).json({ message: "Error fetching memos", error });
    }
  }

  // Memo 조회 (ID로 특정 메모 조회)
  async getMemoById(req, res) {
    const { id } = req.params;
    try {
      const memo = await MemoRepository.getMemoById(id);
      if (!memo) {
        return res.status(404).json({ message: "Memo not found" });
      }
      res.send({
        message: "Memo retrieved successfully",
        data: memo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error fetching memo", error });
    }
  }

  // Memo 수정
  async updateMemo(req, res) {
    const { id } = req.params;
    const { title, content } = req.body;
    console.log(id, title, content);
    try {
      const updatedMemo = await MemoRepository.updateMemo(id, title, content);
      console.log(updatedMemo);
      if (!updatedMemo) {
        return res.send({ message: "Memo not found or not modified" });
      }
      res.send({
        result: "ok",
        data: updatedMemo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error updating memo", error });
    }
  }

  // Memo 삭제
  async deleteMemo(req, res) {
    const { id } = req.params;
    try {
      const deletedMemo = await MemoRepository.deleteMemo(id);
      if (!deletedMemo) {
        return res.send({ message: "Memo not found or not deleted" });
      }
      res.send({
        result: "ok",
        data: deletedMemo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error deleting memo", error });
    }
  }

  // Memo 공유
  async shareMemo(req, res) {
    const { id } = req.params;
    try {
      const sharedMemo = await MemoRepository.shareMemo(id);
      if (!sharedMemo) {
        return res.send({ message: "Memo not found or not shared" });
      }
      res.send({
        result: "ok",
        data: sharedMemo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error sharing memo", error });
    }
  }
}

module.exports = new MemoController();
