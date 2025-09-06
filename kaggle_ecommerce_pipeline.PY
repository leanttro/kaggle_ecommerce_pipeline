# INSTALAÇÃO DE PACOTES:
import requests
import pandas as pd
from sqlalchemy import create_engine
from tabulate import tabulate


# CARREGAMENTO DE PLANILHAS:
clientes = pd.read_csv("olist_customers_dataset.csv")
localizacao = pd.read_csv("olist_geolocation_dataset.csv")
itens = pd.read_csv("olist_order_items_dataset.csv")
pagamentos = pd.read_csv("olist_order_payments_dataset.csv")
avaliacoes = pd.read_csv("olist_order_reviews_dataset.csv")
pedidos = pd.read_csv("olist_orders_dataset.csv")
produtos = pd.read_csv("olist_products_dataset.csv")
vendedores = pd.read_csv("olist_sellers_dataset.csv")
categerias = pd.read_csv("product_category_name_translation.csv")

print(clientes)