const MemoRepository = require("../memo/repository/memoRepository"); // MemoRepository import

class MemoController {
  // Memo 생성
  async createMemo(req, res) {
    try {
      print(req);
      const { title, content } = req.body;
      const newMemo = await MemoRepository.createMemo(title, content);
      res.status(201).json({
        message: "Memo created successfully",
        data: newMemo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error creating memo", error });
    }
  }

  // Memo 조회 (모든 메모)
  async getAllMemos(req, res) {
    try {
      const memos = await MemoRepository.getAllMemos();
      res.status(200).json({
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
      res.status(200).json({
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
    try {
      const updatedMemo = await MemoRepository.updateMemo(id, title, content);
      if (!updatedMemo) {
        return res
          .status(404)
          .json({ message: "Memo not found or not modified" });
      }
      res.status(200).json({
        message: "Memo updated successfully",
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
        return res
          .status(404)
          .json({ message: "Memo not found or not deleted" });
      }
      res.status(200).json({
        message: "Memo deleted successfully",
        data: deletedMemo,
      });
    } catch (error) {
      res.status(500).json({ message: "Error deleting memo", error });
    }
  }
}

module.exports = new MemoController();
