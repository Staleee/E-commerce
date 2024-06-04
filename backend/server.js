
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const mysql = require('mysql2');

const app = express();
const PORT = 4000; 

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, '..', 'frontend'));
app.use('/css', express.static(path.join(__dirname, '..', 'frontend', 'css')));

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root', 
  password: 'balyrebalyre@123',
  database: 'ECOMMERCE'
});


connection.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as ID ' + connection.threadId);
});


app.use(bodyParser.json());


app.get('/', (req, res) => {
 res.render('index.hbs');
});



app.post('/addProduct', (req, res) => {
  console.log('inside the addProduct');
  const { name, price, stockQuantity, ratings, discount, variation, sellerID, brandID, categoryID } = req.body;


  connection.query('SELECT MAX(ProductID) AS maxProductId FROM Products', (err, result) => {
    if (err) {
      console.error('Error querying max ProductID:', err);
      res.status(500).send('Error adding product');
      return;
    }

    const nextProductId = result[0].maxProductId ? result[0].maxProductId + 1 : 1;
    console.log('Next ProductID:', nextProductId);


    const query = 'INSERT INTO Products (ProductID, Name, Price, StockQuantity, Ratings, Discount, Variation, SellerID, BrandID, CategoryID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    const values = [nextProductId, name, price, stockQuantity, ratings || 5, discount || 0, variation || '', sellerID || 1, brandID || 1, categoryID || 1];

    connection.query(query, values, (err, result) => {
      if (err) {
        console.error('Error adding product:', err);
        res.status(500).send('Error adding product');
      } else {
        console.log('Product added successfully');
        res.status(200).send('Product added successfully');
      }
    });
  });
});




app.get('/products', (req, res) => {
  const query = 'SELECT * FROM Products';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching products:', err);
      res.status(500).send('Error fetching products');
    } else {
      res.json(results);
    }
  });
});



app.post('/updateProduct/:productID', (req, res) => {
  const productID = req.params.productID;
  const { name, price, stockQuantity, ratings, discount, variation, sellerID, brandID, categoryID } = req.body;
  const query = 'UPDATE Products SET Name = ?, Price = ?, StockQuantity = ?, Ratings = ?, Discount = ?, Variation = ?, SellerID = ?, BrandID = ?, CategoryID = ? WHERE ProductID = ?';
  connection.query(query, [name, price, stockQuantity, ratings, discount, variation, sellerID, brandID, categoryID, productID], (err, result) => {
    if (err) {
      console.error('Error updating product:', err);
      res.status(500).send('Error updating product');
    } else {
      console.log('Product updated successfully');
      res.redirect('/'); 
    }
  });
});


app.delete('/deleteProduct/:productID', (req, res) => {
  const productID = req.params.productID;
  const query = 'DELETE FROM Products WHERE ProductID = ?';
  connection.query(query, [productID], (err, result) => {
    if (err) {
      console.error('Error deleting product:', err);
      res.status(500).send('Error deleting product');
    } else {
      console.log('Product deleted successfully');
      res.redirect('/');
    }
  });
});


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
