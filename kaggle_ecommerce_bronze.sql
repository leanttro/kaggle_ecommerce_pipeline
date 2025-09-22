-- VISUALIZAÇÃO DE DADOS BRUTOS:
Select * from avaliacoes;
Select * from categorias_produto;
Select * from clientes;
Select * from geolocalizacao;
Select * from itens;
Select * from itens_pedido;
Select * from pagamentos;
Select * from pedidos;
Select * from vendedores;

-- DEFIÇÃO DE CHAVES ESTRANGEIRAS E PRIMÁRIAS  (PRIMARY KEYS)
-- CLIENTES
ALTER TABLE clientes
DROP PRIMARY KEY,
MODIFY COLUMN customer_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (customer_id);
-- PEDIDOS
ALTER TABLE pedidos
DROP PRIMARY KEY,
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN customer_id VARCHAR(50),
ADD PRIMARY KEY (order_id);
-- PRODUTOS
ALTER TABLE produtos
DROP PRIMARY KEY,
MODIFY COLUMN product_id VARCHAR(50) NOT NULL,
MODIFY COLUMN product_category_name VARCHAR(50),
ADD PRIMARY KEY (product_id);
-- VENDEDORES
ALTER TABLE vendedores
DROP PRIMARY KEY,
MODIFY COLUMN seller_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (seller_id);
-- CATEGORIAS
ALTER TABLE categorias_produto
DROP PRIMARY KEY,
MODIFY COLUMN product_category_name VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (product_category_name);
-- ITENS_PEDIDO
ALTER TABLE itens_pedido
DROP PRIMARY KEY,
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN order_item_id INT NOT NULL,
MODIFY COLUMN product_id VARCHAR(50),
MODIFY COLUMN seller_id VARCHAR(50),
ADD PRIMARY KEY (order_id, order_item_id);
-- PAGAMENTOS
ALTER TABLE pagamentos
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN payment_sequential INT NOT NULL,
ADD PRIMARY KEY (order_id, payment_sequential);

-- AVALIACOES
ALTER TABLE avaliacoes
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE avaliacoes
MODIFY COLUMN order_id VARCHAR(50) NOT NULL;

-- ======================================
-- 2. CRIAR RELACIONAMENTOS (FOREIGN KEYS)
-- ======================================
-- pedidos -> clientes
ALTER TABLE pedidos
ADD FOREIGN KEY (customer_id) REFERENCES clientes(customer_id);

-- itens_pedido -> pedidos, produtos, vendedores
ALTER TABLE itens_pedido
ADD FOREIGN KEY (order_id) REFERENCES pedidos(order_id),
ADD FOREIGN KEY (product_id) REFERENCES produtos(product_id),
ADD FOREIGN KEY (seller_id) REFERENCES vendedores(seller_id);

-- pagamentos -> pedidos
ALTER TABLE pagamentos
ADD FOREIGN KEY (order_id) REFERENCES pedidos(order_id);

-- avaliacoes -> pedidos
ALTER TABLE avaliacoes
ADD FOREIGN KEY (order_id) REFERENCES pedidos(order_id);

-- produtos -> categorias_produto
ALTER TABLE produtos
ADD FOREIGN KEY (product_category_name) REFERENCES categorias_produto(product_category_name);

SELECT DISTINCT product_category_name
FROM produtos
WHERE product_category_name NOT IN (
    SELECT product_category_name FROM categorias_produto);

INSERT INTO categorias_produto (product_category_name)
VALUES ('pc_gamer'),
       ('portateis_cozinha_e_preparadores_de_alimentos');
       
SELECT 
    c.customer_id,
    c.customer_unique_id,
    p.order_id,
    p.order_purchase_timestamp,
    pr.product_id,
    pr.product_category_name,
    v.seller_id
FROM pedidos p
JOIN clientes c ON p.customer_id = c.customer_id
JOIN itens_pedido ip ON p.order_id = ip.order_id
JOIN produtos pr ON ip.product_id = pr.product_id
JOIN vendedores v ON ip.seller_id = v.seller_id
LIMIT 10;

SHOW CREATE TABLE pedidos;
SHOW CREATE TABLE itens_pedido;

