-- ------------------------------ VISUALIZAÇÃO DE DADOS LIMPOS: -----------------------------------
Select * from avaliacoes_silver;
Select * from categorias_silver;
Select * from clientes_silver;
Select * from itens_silver;
Select * from pagamentos_silver;
Select * from pedidos_silver;
Select * from vendedores_silver;
--  -----------------------  DEFIÇÃO DE CHAVES PRIMÁRIAS (PRIMARY KEYS) ---------------------------
-- CLIENTES
ALTER TABLE clientes_silver
MODIFY COLUMN customer_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (customer_id);
-- PEDIDOS
ALTER TABLE pedidos_silver
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN customer_id VARCHAR(50),
ADD PRIMARY KEY (order_id);
-- PRODUTOS
ALTER TABLE produtos_silver
MODIFY COLUMN product_id VARCHAR(50) NOT NULL,
MODIFY COLUMN product_category_name VARCHAR(50),
ADD PRIMARY KEY (product_id);
-- VENDEDORES
ALTER TABLE vendedores_silver
MODIFY COLUMN seller_id VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (seller_id);
-- CATEGORIAS
ALTER TABLE categorias_silver
MODIFY COLUMN product_category_name VARCHAR(50) NOT NULL,
ADD PRIMARY KEY (product_category_name);
-- ITENS_PEDIDO
ALTER TABLE itens_silver
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN order_item_id INT NOT NULL,
MODIFY COLUMN product_id VARCHAR(50),
MODIFY COLUMN seller_id VARCHAR(50),
ADD PRIMARY KEY (order_id, order_item_id);
-- PAGAMENTOS
ALTER TABLE pagamentos_silver
MODIFY COLUMN order_id VARCHAR(50) NOT NULL,
MODIFY COLUMN payment_sequential INT NOT NULL,
ADD PRIMARY KEY (order_id, payment_sequential);
-- AVALIACOES
ALTER TABLE avaliacoes_silver
MODIFY COLUMN order_id VARCHAR(50) NOT NULL;
-- ==================================================================================================
--                              CRIAÇÃO DE RELACIONAMENTOS (FOREIGN KEYS)
-- ==================================================================================================
-- pedidos -> clientes
ALTER TABLE pedidos_silver
ADD FOREIGN KEY (customer_id) REFERENCES clientes_silver(customer_id);
-- itens_pedido -> pedidos, produtos, vendedores
ALTER TABLE itens_silver
ADD FOREIGN KEY (order_id) REFERENCES pedidos_silver(order_id),
ADD FOREIGN KEY (product_id) REFERENCES produtos_silver(product_id),
ADD FOREIGN KEY (seller_id) REFERENCES vendedores_silver(seller_id);
-- pagamentos -> pedidos
ALTER TABLE pagamentos_silver
ADD FOREIGN KEY (order_id) REFERENCES pedidos_silver(order_id);
-- avaliacoes -> pedidos
ALTER TABLE avaliacoes_silver
ADD FOREIGN KEY (order_id) REFERENCES pedidos_silver(order_id);
-- produtos -> categorias_produto
ALTER TABLE produtos_silver
ADD FOREIGN KEY (product_category_name) REFERENCES categorias_silver(product_category_name);
-- Adicionando valores a categorias existentes:
SELECT DISTINCT product_category_name
FROM produtos_silver
WHERE product_category_name NOT IN (
    SELECT product_category_name FROM categorias_silver);
INSERT INTO categorias_silver (product_category_name)
VALUES ('pc_gamer'),
       ('portateis_cozinha_e_preparadores_de_alimentos');
-- produtos -> categorias_produto (correta)
ALTER TABLE produtos_silver
ADD FOREIGN KEY (product_category_name) REFERENCES categorias_silver(product_category_name);

-- ==================================================================================================
--                               ANÁLISE EXPLORATÓRIA DE DADOS LIMPOS 
-- ================================================================================================== 
--  Visualização rápida de tabelas:
Select * From Vendedores_silver;
Select * From pedidos_silver;
Select * From itens_silver;
Select * From produtos_silver;
Select * From avaliacoes_silver;
Select * From clientes_silver;
-  --------------------------------------  TOTAL DE VENDA X ANO  --------------------------------------------- 
SELECT FORMAT(SUM(price),2) as TOTAL_VENDAS_2016
FROM itens_silver
WHERE YEAR(shipping_limit_date) = 2016;
-- R$ 49.785,92
SELECT FORMAT(SUM(price),2) as TOTAL_VENDAS_2016
FROM itens_silver
WHERE YEAR(shipping_limit_date) = 2017;
-- R$ 6.034.868,60 
SELECT FORMAT(SUM(price),2) as TOTAL_VENDAS_2016
FROM itens_silver
WHERE YEAR(shipping_limit_date) = 2018;
-- R$ 7.506.643,24 
--  ---------------------------------  MÉDIA DE AVALIAÇÕES ---------------------------------------- 
Select DISTINCT Count(seller_id) From vendedores_silver;
Select FORMAT(AVG(review_score),2) From avaliacoes_silver;
-- 4.09 média de avaliações

--  ---------------------------------  MAIORES VENDEDORES ---------------------------------------- 
SELECT v.seller_id as Vendedor,
	FORMAT(SUM(i.price),2) as R$TOTALVENDAS
FROM itens_silver as i
LEFT JOIN vendedores_silver as v ON v.seller_id = i.seller_id
GROUP BY v.seller_id
ORDER BY SUM(i.price) DESC
LIMIT 10;

--  -----------------  VALORES E TICKET MÉDIO DE VENDAS POR VENDEDORES X ANO  ----------------------  
SELECT v.seller_id as Vendedor,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$VENDAS2017,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN i.price ELSE 0 END),2) AS R$VENDAS2018,
    FORMAT(SUM(i.price),2) AS R$TOTAL_VENDAS,
    FORMAT(AVG(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$MÉDIAVENDAS2016,
    FORMAT(AVG(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$MÉDIAVENDAS2017,
    FORMAT(AVG(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN i.price ELSE 0 END),2) AS R$MÉDIAVENDAS2018,
    FORMAT(AVG(i.price),2) AS R$MÉDIA_VENDAS
FROM itens_silver as i
LEFT JOIN vendedores_silver as v ON v.seller_id = i.seller_id
GROUP BY v.seller_id
HAVING R$MÉDIAVENDAS2017 != 0 
LIMIT 10;

/*
10 MAIORES VENDEDORES (2016):
-- 46dc3b2cc0980fb8ec44634e21d2718e
-- 1554a68530182680ad5c8b042c3ab563
-- 99eaacc9e6046db1c82b163c5f84869f
-- 77530e9772f57a62c906e1c21538ab82
-- b2ba3715d723d245138f291a6fe42594
-- df560393f3a51e74553ab94004ba5c87
-- f4aba7c0bca51484c30ab7bdc34bcdd1
-- fa40cc5b934574b62717c68f3d678b6d
-- 5656537e588803a555b8eb41f07a944b
-- 8a32e327fe2c1b3511609d81aaf9f042

10 MAIORES VENDEDORES (2017):
-- cc419e0650a3c5ba77189a1882b7556a
-- a416b6a846a11724393025641d4edd5e
-- 48436dade18ac8b2bce089ec2a041202
-- dd7ddc04e1b6c2c614352b383efe2d36
-- 7040e82f899a04d1b434b795a43b4617
-- df560393f3a51e74553ab94004ba5c87
-- 6426d21aca402a131fc0a5d0960a3c90
-- 9d7a1d34a5052409006425275ba1c2b4
-- 5b51032eddd242adc84c38acab88f23d
-- 8602a61d680a10a82cceeeda0d99ea3d

10 MAIORES VENDEDORES (2018):
-- 5996cddab893a4652a15592fb58ab8db
-- 5b51032eddd242adc84c38acab88f23d
-- a416b6a846a11724393025641d4edd5e
-- df560393f3a51e74553ab94004ba5c87
-- 48436dade18ac8b2bce089ec2a041202
-- ba143b05f0110f0dc71ad71b4466ce92
-- 9d7a1d34a5052409006425275ba1c2b4
-- dd7ddc04e1b6c2c614352b383efe2d36
-- cc419e0650a3c5ba77189a1882b7556a
-- 7040e82f899a04d1b434b795a43b4617

10 MENORES TICKETS MÉDIOS (2016):
-- fa40cc5b934574b62717c68f3d678b6d
-- 8a32e327fe2c1b3511609d81aaf9f042
-- 5656537e588803a555b8eb41f07a944b
-- b2ba3715d723d245138f291a6fe42594
-- 77530e9772f57a62c906e1c21538ab82
-- f4aba7c0bca51484c30ab7bdc34bcdd1
-- 1554a68530182680ad5c8b042c3ab563
-- 99eaacc9e6046db1c82b163c5f84869f
-- df560393f3a51e74553ab94004ba5c87
-- 46dc3b2cc0980fb8ec44634e21d2718e

10 MENORES TICKETS MÉDIOS (2017):
-- 8602a61d680a10a82cceeeda0d99ea3d
-- 7040e82f899a04d1b434b795a43b4617
-- dd7ddc04e1b6c2c614352b383efe2d36
-- cc419e0650a3c5ba77189a1882b7556a
-- 9d7a1d34a5052409006425275ba1c2b4
-- 5b51032eddd242adc84c38acab88f23d
-- 6426d21aca402a131fc0a5d0960a3c90
-- 48436dade18ac8b2bce089ec2a041202
-- a416b6a846a11724393025641d4edd5e
-- df560393f3a51e74553ab94004ba5c87

10 MENORES TICKETS MÉDIOS (2018):
-- 7040e82f899a04d1b434b795a43b4617
-- cc419e0650a3c5ba77189a1882b7556a
-- dd7ddc04e1b6c2c614352b383efe2d36
-- 9d7a1d34a5052409006425275ba1c2b4
-- ba143b05f0110f0dc71ad71b4466ce92
-- 48436dade18ac8b2bce089ec2a041202
-- df560393f3a51e74553ab94004ba5c87
-- a416b6a846a11724393025641d4edd5e
-- 5b51032eddd242adc84c38acab88f23d
-- 5996cddab893a4652a15592fb58ab8db
*/
--  -----------------------  SCORE E QUANTIDADE DE AVALIAÇÕES X VENDEDORES  ------------------------  
Select v.seller_id as VENDEDORES, 
	AVG(a.review_score) as MÉDIA_avaliações, 
	COUNT(p.order_id) as QUANT_VENDAS,
	COUNT(a.review_score) as QUANT_avaliações,
	((COUNT(p.order_id) )-(COUNT(a.review_score)) ) as QUANT_NÃO_AVALIADA,
	SUM(a.review_score) as SOMA_pontuação
From vendedores_silver as v
LEFT JOIN itens_silver as i ON i.seller_id = v.seller_id
LEFT JOIN pedidos_silver as p ON i.order_id = p.order_id
LEFT JOIN avaliacoes_silver as a ON a.order_id = i.order_id
Group By v.seller_id
Having QUANT_VENDAS > 0 AND QUANT_VENDAS < 2000;



--  -------------------------------   PORCENTAGEM DE REINCIDÊNCIA -------------------------------  
SELECT 
    COUNT(DISTINCT c.customer_id) AS clientes_unicos,
    COUNT(c.customer_id) AS total_vendas,
    (COUNT(c.customer_id) - COUNT(DISTINCT c.customer_id)) AS clientes_recorrentes,
    COUNT(DISTINCT c.customer_id) - (COUNT(c.customer_id) - COUNT(DISTINCT c.customer_id)) AS clientes_1compra
FROM kaggle_silver.itens_silver i
LEFT JOIN kaggle_silver.pedidos_silver p ON i.order_id = p.order_id
LEFT JOIN kaggle_silver.clientes_silver c ON p.customer_id = c.customer_id;


/*
3 PIORES MÉDIAS DE ANALIAÇÕES ATÉ 20 VENDAS:
-- 001e6ad469a905060d959994f1b41e4f
-- 010da0602d7774602cd1b3f5fb7b709e
-- 010da0602d7774602cd1b3f5fb7b709e

3 PIORES MÉDIAS DE ANALIAÇÕES 21 - 100 VENDAS:
-- 2709af9587499e95e803a6498a5a56e9
-- 2709af9587499e95e803a6498a5a56e9
-- ec4608a1f76453166bb312b2968aeaf4

3 PIORES MÉDIAS DE ANALIAÇÕES 101 - 500 VENDAS:
-- 1ca7077d890b907f89be8c954a02686a
-- 2eb70248d66e0e3ef83659f71b244378
-- a49928bcdf77c55c6d6e05e09a9b4ca5 

3 PIORES MÉDIAS DE ANALIAÇÕES 501 - 1000 VENDAS:
-- 1900267e848ceeba8fa32d80c1a5f5a8
-- 391fc6631aebcf3004804e51b40bcf1e
-- 1025f0e2d44d7041d6cf58b6550e0bfa


3 PIORES MÉDIAS DE ANALIAÇÕES 1001 - 1500 VENDAS:
-- 7c67e1448b00f6e969d365cea6b010ab
-- 1025f0e2d44d7041d6cf58b6550e0bfa
-- ea8482cd71df3c1969d7b9473ff13abc
*/
--  ------------------------------  VENDAS X AVALIAÇÕES (VENDEDORES)  ------------------------------ 
Select v.seller_id as vendedor, 
	sum(a.review_score) as soma_avaliações, 
	count(a.review_score) as quantidade_avaliações,
	count(p.order_id) as quant_vendas, 
	FORMAT(SUM(i.price),2) as R$_Vendas
From vendedores_silver as v
	Left Join itens_silver as i ON v.seller_id = i.seller_id
	Left Join pedidos_silver as p ON p.order_id = i.order_id
	Left Join avaliacoes_silver as a ON  a.order_id = i.order_id
Group by v.seller_id
ORDER BY soma_avaliações DESC;
--  -----------------------------  VENDAS X VENDEDOR/A (SELECIONADO/A)  --------------------------- 
Select v.seller_id as Vendedor_SELECIONADO,
	pr.product_id as ID_PRODUTO, 
    i.price as preço,
	pr.product_category_name as categoria 
From produtos_silver as pr 
	LEFT JOIN itens_silver as i ON i.product_id = pr.product_id
	LEFT JOIN vendedores_silver as v ON v.seller_id = i.seller_id
WHERE v.seller_id = "5c853bb56f70f4d14218944bae111d7a";

--  ---------------------  TOTAL DE VENDAS ANUAIS E TICKET MÉDIO X CATEGORIAS  ---------------------- 
SELECT p.product_category_name AS categoria,
	FORMAT(SUM(i.price),2) AS R$TOTAL_VENDAS,
	FORMAT(AVG(i.price),2) AS TICKET_MÉDIO,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$VENDAS2017,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN i.price ELSE 0 END),2) AS R$VENDAS2018
FROM produtos_silver as p
LEFT JOIN itens_silver as i ON i.product_id = p.product_id
GROUP BY categoria ORDER BY SUM(i.price) DESC;

/*
10 CATEGORIAS COM MAIORES VALORES DE VENDAS:
-- beleza_saude
-- relogios_presentes
-- cama_mesa_banho
-- esporte_lazer
-- informatica_acessorios
-- moveis_decoracao
-- cool_stuff
-- utilidades_domesticas
-- automotivo
-- ferramentas_jardim

10 CATEGORIAS COM MAIORES TICKETS MÉDIOS:
-- pcs
-- portateis_casa_forno_e_cafe
-- eletrodomesticos_2
-- agro_industria_e_comercio
-- instrumentos_musicais
-- eletroportateis
-- portateis_cozinha_e_preparadores_de_alimentos
-- telefonia_fixa
-- construcao_ferramentas_seguranca
-- relogios_presentes
*/
--  -------------------------  CATEGORIAS ADICIONADAS POR ANO X VALORES  ---------------------------
-- CATEGORIAS ADICIONADAS EM 2016:
SELECT p.product_category_name AS ADICIONADOS_EM_2016,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016
FROM produtos_silver as p
JOIN itens_silver as i ON i.product_id = p.product_id
GROUP BY ADICIONADOS_EM_2016
HAVING R$VENDAS2016 != 0 ORDER BY SUM(i.price) DESC;

-- CATEGORIAS ADICIONADAS EM 2017:
SELECT p.product_category_name AS ADICIONADOS_EM_2017,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$VENDAS2017
FROM produtos_silver as p
LEFT JOIN itens_silver as i ON i.product_id = p.product_id
GROUP BY ADICIONADOS_EM_2017
HAVING R$VENDAS2016 = 0 
AND R$VENDAS2017 != 0
ORDER BY SUM(i.price) DESC;

-- CATEGORIAS ADICIONADAS EM 2018:
SELECT p.product_category_name AS ADICIONADOS_EM_2018,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$VENDAS2017,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN i.price ELSE 0 END),2) AS R$VENDAS2018
FROM produtos_silver as p
JOIN itens_silver as i ON i.product_id = p.product_id
GROUP BY ADICIONADOS_EM_2018
HAVING R$VENDAS2016 = 0 
AND R$VENDAS2017 = 0
AND R$VENDAS2018 != 0
ORDER BY SUM(i.price) DESC;

--  ---------------------------  VENDAS ANUAIS E TICKET MÉDIO POR ESTADO  ------------------------------
Select c.customer_state as ESTADO, 
	FORMAT(SUM(i.price),2) AS R$TOTALVENDAS,
    FORMAT(AVG(i.price),2) AS TICKET_MÉDIO,
    FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN i.price ELSE 0 END),2) AS R$VENDAS2016,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN i.price ELSE 0 END),2) AS R$VENDAS2017,
	FORMAT(SUM(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN i.price ELSE 0 END),2) AS R$VENDAS2018
FROM produtos_silver as p
LEFT Join itens_silver as i ON i.product_id = p.product_id
LEFT Join pedidos_silver as pe ON pe.order_id = i.order_id
LEFT Join clientes_silver as c ON c.customer_id = pe.customer_id
GROUP BY c.customer_state
ORDER BY SUM(i.price) DESC;

--  ---------------  CATEGORIAS COM MAIORES VALORES E TICKETS MÉDIOS POR ESTADO ------------------
Select c.customer_state as ESTADO, 
	p.product_category_name as CATEGORIAS_MAIS_VENDIDA,
	FORMAT(SUM(i.price),2) AS R$TOTALVENDAS,
    FORMAT(AVG(i.price),2) AS TICKET_MÉDIO
FROM produtos_silver as p
LEFT Join itens_silver as i ON i.product_id = p.product_id
LEFT Join pedidos_silver as pe ON pe.order_id = i.order_id
LEFT Join clientes_silver as c ON c.customer_id = pe.customer_id
GROUP BY c.customer_state, p.product_category_name 
ORDER BY SUM(i.price) DESC;

--  -------------------------  ANÁLISE MENSAL DE 2016,2017,2018 -----------------------------------
Select
MONTH(i.shipping_limit_date) as MES,
YEAR(i.shipping_limit_date) as ANO,
FORMAT(SUM(i.price),2) AS R$TOTALVENDAS,
FORMAT(AVG(i.price),2) AS R$TICKETMÉDIO
FROM itens_silver as i
group by MES, ANO ORDER BY SUM(i.price) DESC;


--  --------------------  VENDAS POR CATEGORIA - SEM REINCIDÊNCIA  --------------------------
SELECT p.product_category_name AS categoria_SEM_REINCIDÊNCIA,
	COUNT(DISTINCT c.customer_id) AS QUANTvendas,
	COUNT(DISTINCT CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN c.customer_id ELSE 0 END) AS QUANTvendas2016,
	COUNT(DISTINCT CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN c.customer_id ELSE 0 END) AS QUANTvendas2017,
	COUNT(DISTINCT CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN c.customer_id ELSE 0 END) AS QUANTvendas2018
FROM produtos_silver as p
LEFT JOIN itens_silver as i ON i.product_id = p.product_id
LEFT Join pedidos_silver as pe ON pe.order_id = i.order_id
LEFT Join clientes_silver as c ON c.customer_id = pe.customer_id
GROUP BY categoria_SEM_REINCIDÊNCIA ORDER BY COUNT(c.customer_id) DESC;

--  --------------------  VENDAS POR CATEGORIA - COM REINCIDÊNCIA  --------------------------
SELECT p.product_category_name AS categoria_COM_REINCIDÊNCIA,
	COUNT(c.customer_id) AS QUANTvendas,
	COUNT(CASE WHEN YEAR(i.shipping_limit_date) = 2016 THEN c.customer_id ELSE 0 END) AS QUANTvendas2016,
	COUNT(CASE WHEN YEAR(i.shipping_limit_date) = 2017 THEN c.customer_id ELSE 0 END) AS QUANTvendas2017,
	COUNT(CASE WHEN YEAR(i.shipping_limit_date) = 2018 THEN c.customer_id ELSE 0 END) AS QUANTvendas2018
FROM produtos_silver as p
LEFT JOIN itens_silver as i ON i.product_id = p.product_id
LEFT Join pedidos_silver as pe ON pe.order_id = i.order_id
LEFT Join clientes_silver as c ON c.customer_id = pe.customer_id
GROUP BY categoria_COM_REINCIDÊNCIA ORDER BY COUNT(c.customer_id) DESC;

--  -----------------------------  ANÁLISE DE REINCIDÊNCIAS  -------------------------------------
SELECT pr.product_category_name AS categoria,
    COUNT(DISTINCT c.customer_id) AS clientes_unicos,
    COUNT(c.customer_id) AS QUANT_VENDAS,
    (COUNT(c.customer_id) - COUNT(DISTINCT c.customer_id)) AS reincidencias
FROM produtos_silver AS pr
LEFT JOIN kaggle_silver.itens_silver i ON pr.product_id = i.product_id
LEFT JOIN kaggle_silver.pedidos_silver p ON p.order_id = i.order_id
LEFT JOIN kaggle_silver.clientes_silver c ON p.customer_id = c.customer_id
GROUP BY pr.product_category_name
ORDER BY  QUANT_VENDAS DESC;










--  Visualização rápida de tabelas:
Select * From Vendedores_silver;
Select * From pedidos_silver;
Select * From itens_silver;
Select * From produtos_silver;
Select * From avaliacoes_silver;
Select * From clientes_silver;
Select * From categorias_silver;













