const Sequelize = require('sequelize');

const user = 'Pete';
const password = '8gxx789tnqe&pMELm&YpYgy4L';
const host = 'localhost';
const database = 'testingpassport';

const sequelize = new Sequelize(database, user, password, {
  host,
  dialect: 'postgres',
  logging: false,
});

module.exports = sequelize;
