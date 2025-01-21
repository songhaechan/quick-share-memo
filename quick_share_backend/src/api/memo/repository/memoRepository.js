const { pool } = require("../../../database/index"); // 데이터베이스 연결

exports.createMemo = async (title, content, createdAt, userId) => {
  const query = `INSERT INTO memos (title, content, created_at, isOpened, user_id) VALUES (?, ?, ?, ?, ?)`;
  return await pool.query(query, [title, content, createdAt, false, userId]);
};

// Memo 조회 (개인의 모든 메모)
exports.getAllMemos = async (userId) => {
  const query = `SELECT * FROM memos WHERE isOpened = false and user_id = ?`;
  const result = await pool.query(query, userId);
  return result.length > 0 ? result : null;
};

// Memo 조회 (ID로 특정 메모)
exports.getMemoById = async (id) => {
  const query = `SELECT * FROM memos WHERE id = ?`;
  const result = await pool.query(query, [id]);
  return result.length > 0 ? result : null;
};

// Memo 수정
exports.updateMemo = async (id, title, content) => {
  const query = `UPDATE memos SET title = ?, content = ? WHERE id = ?`;
  const result = await pool.query(query, [title, content, `${id}`]);
  console.log(result);
  return result.affectedRows > 0; // 수정된 행의 수로 성공 여부 판단
};

// Memo 삭제
exports.deleteMemo = async (id) => {
  const query = `DELETE FROM memos WHERE id = ?`;
  const result = await pool.query(query, [id]);
  return result.affectedRows > 0; // 삭제된 행의 수로 성공 여부 판단
};

exports.shareMemo = async (id) => {
  const query = `UPDATE memos SET isOpened = true`;
  const result = await pool.query(query);
  return result.affectedRows > 0; // 삭제된 행의 수로 성공 여부 판단
};
