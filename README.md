# Projeto de Análise de E-commerce | Olist Dataset

## Status do Projeto: Em Desenvolvimento

Este projeto está atualmente na sua primeira versão, com um pipeline de dados totalmente funcional em ambiente local. A próxima fase, que está em planejamento e desenvolvimento, é a migração completa da solução para um ambiente de nuvem (Google Cloud Platform).

## Visão Geral do Projeto

Este projeto apresenta uma solução de Business Intelligence e Data Engineering para análise de dados do dataset Olist. O objetivo é transformar dados brutos de e-commerce em insights acionáveis, através da construção de um pipeline de dados ponta a ponta, desde a ingestão até a visualização.

## Problema de Negócio

O principal desafio é responder a perguntas de negócio cruciais para diferentes áreas da empresa, como Vendas, Logística, Marketing e Gestão de Vendedores, permitindo uma tomada de decisão orientada por dados.

## Arquitetura da Solução

O projeto está sendo desenvolvido em duas fases principais de arquitetura:

### Fase 1: Arquitetura Local (Implementada)
- **Fluxo:** `Arquivos CSV` -> `Jupyter/Python (ETL)` -> `MySQL (Silver/Gold)` -> `Power BI (Visualização)`
- **Descrição:** Um pipeline de dados local que processa os arquivos CSV, aplica transformações e os armazena em um banco de dados MySQL. O Power BI se conecta a este banco para criar os relatórios.

### Fase 2: Arquitetura em Nuvem (Próxima Etapa)
- **Fluxo Planejado:** `GCS (Bronze)` -> `Cloud Functions/Jupyter (ETL)` -> `BigQuery (Silver/Gold)` -> `Power BI (Visualização)`
- **Descrição:** Evolução da solução para uma arquitetura serverless e escalável na GCP. Os dados brutos serão armazenados no Cloud Storage, processados e carregados no BigQuery, que servirá como Data Warehouse para a análise no Power BI.

## Tecnologias Utilizadas

- **Linguagem:** Python 3
- **Bibliotecas de ETL:** Pandas, SQLAlchemy, pandas-gbq (será utilizado na Fase 2)
- **Banco de Dados:** MySQL (Fase 1)
- **Cloud & Data Warehouse:** Google Cloud Platform, Google Cloud Storage, Google BigQuery (Fase 2)
- **Business Intelligence:** Microsoft Power BI

## Estrutura do Repositório

```
.
├── dados/                       # Pasta com os datasets .csv originais da Olist
├── kaggle_ecommerce.ipynb       # Jupyter Notebook com o processo de ETL local
├── kaggle_olist.pbix            # Arquivo do Power BI com os dashboards
├── visualizacoes_kaggle_gold.sql # Scripts SQL para criar as views da camada Gold
└── README.md                    # Documentação do projeto
```
*(Nota: Novos scripts, como o de migração para a nuvem, serão adicionados conforme o projeto avança).*

## Como Executar a Fase Atual (Local)

1.  **Pré-requisitos:**
    - Python 3.x e MySQL Server instalados.
    - Power BI Desktop instalado.

2.  **Clone este repositório:**
    ```bash
    git clone [[URL_DO_SEU_REPOSITORIO](https://github.com/leanttro/kaggle_ecommerce_pipeline.git)]
    ```

3.  **Instale as dependências:**
    ```bash
    pip install pandas sqlalchemy mysql-connector-python
    ```

4.  **Execução do Pipeline:**
    - Configure suas credenciais do banco de dados MySQL no notebook `kaggle_ecommerce.ipynb`.
    - Execute o notebook para processar os dados e popular as tabelas no seu banco local.

5.  **Visualização:**
    - Abra o arquivo `kaggle_olist.pbix` no Power BI.
    - Conecte o dashboard ao seu banco de dados MySQL local.

## Próximos Passos

- [ ] Finalizar o script de migração de dados do MySQL para o Google BigQuery.
- [ ] Refatorar o pipeline de ETL para operar em um ambiente de nuvem (GCP).
- [ ] Documentar o processo de implantação e a nova arquitetura em nuvem.

## Autor

**Leandro Andrade de Oliveira**
- LinkedIn: [[seu-linkedin](https://www.linkedin.com/in/leanttro/)]
