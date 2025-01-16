const { pool } = require("../../../database/index");
exports.register = async (id, password) => {
  const query = `INSERT INTO user
(login_id, password)
VALUES (?,?)`;
  return await pool.query(query, [id, password]);
};
exports.login = async (loginId, password) => {
  const query = `SELECT * FROM user WHERE
login_id = ? AND password = ?`;
  let result = await pool.query(query, [loginId, password]);
  return result.length < 0 ? null : result[0];
};
exports.findByLoginId = async (loginId) => {
  let result = await pool.query(
    `SELECT count(*) count FROM user
where login_id = ?`,
    [loginId]
  );
  return result.length < 0 ? null : result[0];
};
exports.findId = async (id) => {
  const result = await pool.query(
    `SELECT id, name, phone, created_at FROM user WHERE id = ?`,
    [id]
  );
  return result.length < 0 ? null : result[0];
};
exports.update = async (id, name, image) => {
  const profileId = image === undefined ? null : image;
  const query = `UPDATE user SET name = ?, profile_id = ? WHERE
    id = ?`;
  return await pool.query(query, [name, profileId, id]);
};
