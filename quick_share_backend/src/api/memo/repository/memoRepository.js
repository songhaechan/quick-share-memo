const { pool } = require("../../../database/index"); // 데이터베이스 연결

// Memo 생성
exports.createMemo = async (title, content) => {
  const query = `INSERT INTO memo_db (title, content) VALUES (?, ?)`;
  return await pool.query(query, [title, content]);
};

// Memo 조회 (모든 메모)
exports.getAllMemos = async () => {
  const query = `SELECT * FROM memo_db`;
  const result = await pool.query(query);
  return result.length > 0 ? result : null;
};

// Memo 조회 (ID로 특정 메모)
exports.getMemoById = async (id) => {
  const query = `SELECT * FROM memo_db WHERE id = ?`;
  const result = await pool.query(query, [id]);
  return result.length > 0 ? result[0] : null;
};

// Memo 수정
exports.updateMemo = async (id, title, content) => {
  const query = `UPDATE memos SET title = ?, content = ? WHERE id = ?`;
  const result = await pool.query(query, [title, content, price, id]);
  return result.affectedRows > 0; // 수정된 행의 수로 성공 여부 판단
};

// Memo 삭제
exports.deleteMemo = async (id) => {
  const query = `DELETE FROM memo_db WHERE id = ?`;
  const result = await pool.query(query, [id]);
  return result.affectedRows > 0; // 삭제된 행의 수로 성공 여부 판단
};
