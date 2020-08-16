const express = require('express');
const app = express();
app.set('view engine', 'pug');
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => res.render('signup'));
app.listen(3001, () => console.log('Server ready'));
app.post('/register', async (req, res) => {
  const { email, password } = req.body;
});
