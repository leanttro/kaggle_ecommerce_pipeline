# Projeto de Business Intelligence e Engenharia de Dados | E-commerce Olist

## Status do Projeto: Fase 2 Concluída ✅

Este projeto demonstra a construção de uma solução de dados ponta a ponta, desde a ingestão e processamento local até a migração e análise em um ambiente de nuvem robusto e escalável. A **Fase 1 (Arquitetura Local)** e a **Fase 2 (Migração para Nuvem e Dashboard de Logística)** estão concluídas. A próxima etapa será o desenvolvimento do dashboard Financeiro.

## Visão Geral do Projeto

Este projeto apresenta uma solução completa de BI e Engenharia de Dados para análise do dataset Olist. O objetivo é transformar dados brutos de e-commerce em insights acionáveis, cobrindo diferentes áreas de negócio e evoluindo de uma arquitetura local para uma solução *serverless* na Google Cloud Platform (GCP).

## Problema de Negócio

O principal desafio é responder a perguntas de negócio cruciais para diferentes áreas da empresa — como Marketing, Logística e Finanças — permitindo uma tomada de decisão ágil e orientada por dados.

## Arquitetura da Solução

### Fase 1: Arquitetura Local (Implementada)
- **Fluxo:** `Arquivos CSV` -> `Jupyter/Python (ETL)` -> `MySQL (Camadas Silver/Gold)` -> `Power BI (Visualização)`
- **Descrição:** Um pipeline de dados inicial que processa os arquivos CSV, aplica transformações e os armazena em um banco de dados MySQL.

### Fase 2: Arquitetura em Nuvem (Implementada)
- **Fluxo:** `Python Script (ETL)` -> `GCS (Landing Zone)` -> `BigQuery (Data Warehouse com camadas Silver/Gold)` -> `Power BI (Visualização)`
- **Descrição:** Evolução da solução para uma arquitetura *serverless* e escalável na GCP. Scripts em Python migraram os dados para o Google Cloud Storage (GCS). De lá, foram carregados no BigQuery, que atua como Data Warehouse central. Para otimizar as consultas, foram criadas *views materializadas* na camada Gold.

## Tecnologias Utilizadas

- **Linguagem:** Python 3
- **Bibliotecas de ETL:** Pandas, SQLAlchemy, pandas-gbq
- **Banco de Dados (Fase 1):** MySQL
- **Cloud & Data Warehouse (Fase 2):** Google Cloud Platform (GCP), Google Cloud Storage (GCS), Google BigQuery
- **Business Intelligence:** Microsoft Power BI

## Dashboards Desenvolvidos

### 1. Dashboard de Marketing
- Focado em analisar a performance de vendas, canais de aquisição e perfil de clientes.

### 2. Dashboard de Logística 📊
- Projetado para transformar dados brutos de entrega em insights para otimizar a operação. Responde a perguntas de negócio como:
    - *"Onde estão nossos gargalos de entrega?"*
    - *"Nossas entregas são eficientes em relação ao SLA?"*
    - *"O custo do frete se justifica pela velocidade?"*
- **KPIs e Análises Principais:**
    - **Monitoramento de SLA:** Entregas no prazo vs. Atrasadas.
    - **Análise de Gargalos:** Decompõe o tempo de entrega em fases (aprovação, preparo, transporte) para identificar a maior demora por estado (UF).
    - **Custo vs. Tempo:** Gráfico de dispersão que analisa a correlação entre o valor do frete e a velocidade da entrega.
    - **Performance Temporal:** Evolução da eficiência logística ao longo dos anos.

## Como Executar

### Versão 2 (Nuvem - GCP)
A execução deste pipeline ocorre em ambiente de nuvem. Os principais passos são:
1.  **Ingestão:** Os dados tratados são enviados para um bucket no Google Cloud Storage.
2.  **Data Warehouse:** O BigQuery é populado com os dados do GCS, onde as tabelas das camadas Silver e Gold são criadas.
3.  **Visualização:** O Power BI se conecta diretamente ao BigQuery para consumir os dados e alimentar os dashboards de Marketing e Logística.

### Versão 1 (Local)
1.  **Pré-requisitos:** Python 3.x, MySQL Server e Power BI Desktop instalados.
2.  **Clone o repositório:** `git clone https://github.com/leanttro/kaggle_ecommerce_pipeline.git`
3.  **Instale as dependências:** `pip install pandas sqlalchemy mysql-connector-python`
4.  **Execute o ETL:** Configure suas credenciais do MySQL no notebook e execute-o para popular o banco de dados local.
5.  **Visualize:** Abra o arquivo `.pbix` e conecte o dashboard ao seu banco de dados MySQL.

## Próximos Passos

- [ ] **Fase 3 [FINANCEIRO]:** Desenvolvimento de um novo dashboard focado em análise financeira, respondendo perguntas sobre receita, ticket médio, custos de frete e comissão.
- [ ] Construir o pipeline de dados para a camada financeira no BigQuery.
- [ ] Documentar a modelagem e as regras de negócio da área Financeira.

## Autor

**Leandro Andrade de Oliveira**
- **LinkedIn:** [linkedin.com/in/leanttro/](https://www.linkedin.com/in/leanttro/)
