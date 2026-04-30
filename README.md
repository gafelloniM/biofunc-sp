```markdown
# BioFunc-SP: Dashboard IA para Predição Ecológica e Nexo Água-Saúde 💧🔬

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19931824.svg)](https://doi.org/10.5281/zenodo.19931824)
[![Status](https://img.shields.io/badge/Status-Beta%20%2F%20WIP-orange)]()
[![R](https://img.shields.io/badge/R-4.0+-blue.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **⚠️ AVISO DE VERSÃO (BETA / WORK IN PROGRESS)**
> Este software está atualmente em fase de desenvolvimento ativo. Os dados presentes nesta versão (`v0.1.0`) são gerados de forma randômica (simulada) para fins de demonstração da arquitetura lógica, testes de interface e validação dos algoritmos multivariados. A integração com bases de dados reais e matrizes limnológicas definitivas está prevista para os próximos lançamentos.

## 📖 Sobre o Projeto

O **BioFunc-SP** é uma aplicação web desenvolvida em R/Shiny focada no monitoramento geoespacial, análise de traços funcionais da comunidade bentônica e avaliação da qualidade da água no Estado de São Paulo. 

Idealizado como uma ferramenta de apoio à tomada de decisão para gestores ambientais e uma plataforma de pesquisa avançada, o dashboard traduz matrizes complexas de dados ecológicos em diagnósticos visuais, enquadramentos legais (CONAMA 357/2005) e, de forma inovadora, calcula o impacto socioeconômico da qualidade da água na saúde pública (Doenças Diarreicas Agudas - DDA) e nos custos de tratamento.

**Autor:** Dr. Gabriel Feloni Martins do Rosário  
**Instituição Vinculada:** Universidade de São Paulo (USP) - *Proposta em desenvolvimento*

## 🚀 Funcionalidades Principais

O sistema está dividido em 9 módulos integrados:

1. **Monitoramento Estadual:** Mapeamento interativo (Gêmeo Digital) das Unidades de Gerenciamento de Recursos Hídricos (UGRHIs).
2. **Traços Funcionais:** Assinaturas da fauna bentônica (Estratégia Respiratória, Guildas Tróficas e Grupos Bioindicadores).
3. **Estatística Multivariada:** PCA Biplot, Matrizes de Correlação e Machine Learning (Feature Importance via Gini Index).
4. **Legislação & Limnologia:** Cruzamento de OD/DBO com as classes do CONAMA.
5. **Auditoria de Fluxo:** Avaliação da capacidade de autodepuração dos rios (Montante vs. Jusante).
6. **Ecologia de Redes:** Simulação de resiliência da teia trófica sob estresse ambiental.
7. **Simulador & Clima:** Projeções do Índice de Qualidade (IQF) sob anomalias climáticas (secas/aquecimento).
8. **Nexo Saúde & Economia:** Cálculo preditivo de ROI ambiental, cruzando dados de saneamento com leitos do SUS.
9. **Datalake:** Acesso à matriz bruta de dados (RLQ).

## 🛠️ Instalação e Execução Local

Para rodar este aplicativo em sua própria máquina, você precisará do R e do RStudio instalados.

1. Clone este repositório:
   ```bash
   git clone [https://github.com/SEU_USUARIO/app-predicao-fauna.git](https://github.com/SEU_USUARIO/app-predicao-fauna.git)
   ```
2. Abra o projeto no RStudio.
3. O script possui uma rotina automatizada que verifica e instala as dependências necessárias. Os pacotes exigidos incluem:
   `shiny`, `shinydashboard`, `ggplot2`, `dplyr`, `leaflet`, `DT`, `tidyr`, `ggrepel`, `plotly`, `scales`, `reshape2`, `visNetwork`, `shinyWidgets`.
4. Execute o arquivo `app.R` clicando em **Run App** no RStudio.

## 📊 Estrutura dos Dados de Entrada

Para o pleno funcionamento das predições, o sistema espera um *data frame* com a seguinte estrutura conceitual:

| Variável | Tipo | Descrição |
| :--- | :--- | :--- |
| `ID` | Texto | Identificador único da estação de coleta (ex: CETESB_0001) |
| `UGRHI` | Texto | Bacia hidrográfica de pertencimento |
| `Lat` / `Lon` | Numérico | Coordenadas geográficas (WGS84) |
| `OD` | Numérico | Oxigênio Dissolvido (mg/L) |
| `DBO` | Numérico | Demanda Bioquímica de Oxigênio (mg/L) |
| `Fosforo` | Numérico | Fósforo Total (mg/L) |
| `Metais` | Numérico | Índice de Carga Tóxica / Metais Pesados |
| `Mata_Ciliar` | Numérico | Cobertura percentual de dossel/mata no trecho (%) |
| `Turbidez` | Numérico | Nível de turbidez (NTU) |
| `Posicao` | Categórico | Fator indicando trecho de `Montante` ou `Jusante` |

> **Nota Técnica sobre Dados Ausentes (NA):** Nas matrizes biológicas e ambientais futuras a serem integradas, os valores de `NA` não significam, necessariamente, erro de medição. Eles podem representar o valor zero (em percentuais) ou a "ausência" de uma determinada espécie na amostra limnológica.

## 🛤️ Próximos Passos (Roadmap)

- [ ] Substituição dos dados simulados (`set.seed`) por planilhas reais de monitoramento estadual.
- [ ] Refinamento dos modelos ecológicos para bioindicadores, ajustando o comportamento de espécies oportunistas (como determinados Oligochaetas) que proliferam em gradientes de condições intermediárias, não limitando-os apenas a indicadores de severa poluição.
- [ ] Padronização tipográfica nas saídas gráficas estatísticas (garantir que as etiquetas da PCA plotem as variâncias estritamente como **R²**, e não R2 ou r2).
- [ ] Implementação de upload reativo de arquivos `.csv` pelo próprio usuário.

## 📜 Citação

Se você utilizar este software ou parte de seu código em sua pesquisa, por favor, cite da seguinte forma:

> do Rosário, G. F. M. (2026). *BioFunc-SP: Dashboard IA para Predição Ecológica e Nexo Água-Saúde*. [Software]. Zenodo. https://doi.org/10.5281/zenodo.19931824

## ⚖️ Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
```

Após colar isso no seu RStudio, é só salvar, fazer o **Commit** e depois o **Push** para enviar para o GitHub!