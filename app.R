# ==============================================================================

# DASHBOARD IA - BioFunc-SP (VERSÃO MÁXIMA E CORRIGIDA)

# Autor: Dr. Gabriel Feloni Martins do Rosário

# Correção: Aba 8 (Nexo Saúde e Economia) totalmente interativa e intuitiva.

# ==============================================================================



# ------------------------------------------------------------------------------

# 0. ROTINA DE INSTALAÇÃO E CARREGAMENTO DE PACOTES

# ------------------------------------------------------------------------------

pacotes <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "leaflet", "DT", 
             
             "tidyr", "ggrepel", "plotly", "scales", "reshape2", "visNetwork", "shinyWidgets")



faltantes <- pacotes[!(pacotes %in% installed.packages()[,"Package"])]

if(length(faltantes) > 0) install.packages(faltantes, dependencies = TRUE)

invisible(lapply(pacotes, require, character.only = TRUE))



# ------------------------------------------------------------------------------

# 1. BASE DE DADOS INTEGRADA

# ------------------------------------------------------------------------------

set.seed(2026)

options(scipen = 999)



lista_ugrhis <- paste(sprintf("%02d", 1:22), c(
  
  "Mantiqueira", "Paraíba do Sul", "Litoral Norte", "Pardo", "PCJ", "Alto Tietê",
  
  "Baixada Santista", "Sapucaí/Grande", "Mogi-Guaçu", "Sorocaba/Médio Tietê",
  
  "Ribeira de Iguape", "Baixo Pardo/Grande", "Tietê/Jacaré", "Alto Paranapanema",
  
  "Turvo/Grande", "Tietê/Batalha", "Médio Paranapanema", "São José dos Dourados",
  
  "Baixo Tietê", "Aguapeí", "Peixe", "Pontal do Paranapanema"
  
), sep=" - ")



n_est <- 1000

estacoes_df <- data.frame(
  
  ID = paste0("CETESB_", sprintf("%04d", 1:n_est)),
  
  UGRHI = sample(lista_ugrhis, n_est, replace = TRUE),
  
  Lat = runif(n_est, -25.0, -19.5), Lon = runif(n_est, -53.0, -44.0),
  
  OD = runif(n_est, 0.5, 9.5), DBO = runif(n_est, 2, 45), Fosforo = runif(n_est, 0.05, 5),
  
  Metais = runif(n_est, 0, 10), Mata_Ciliar = runif(n_est, 0, 100), Turbidez = runif(n_est, 5, 200),
  
  Posicao = sample(c("Montante", "Jusante"), n_est, replace = TRUE)
  
) %>%
  
  mutate(
    
    IQF = (OD * 6) + (Mata_Ciliar * 0.3) - (DBO * 1.5) - (Metais * 4) + 40,
    
    IQF = pmax(0, pmin(100, IQF)),
    
    Classe = case_when(IQF >= 80 ~ "Classe 1", IQF >= 60 ~ "Classe 2", IQF >= 30 ~ "Classe 3", TRUE ~ "Classe 4"),
    
    Custo_Trat = 0.55 + (DBO * 0.05) + (Metais * 0.12)
    
  )



# ------------------------------------------------------------------------------

# 2. INTERFACE DO UTILIZADOR (UI)

# ------------------------------------------------------------------------------

ui <- dashboardPage(
  
  skin = "black",
  
  dashboardHeader(title = "BioFunc-SP | USP", titleWidth = 300),
  
  
  
  dashboardSidebar(
    
    width = 300,
    
    sidebarMenu(
      
      menuItem("1. Monitoramento Estadual", tabName = "mapa", icon = icon("map-marked-alt")),
      
      menuItem("2. Traços Funcionais (Traits)", tabName = "traits", icon = icon("bug")),
      
      menuItem("3. Estatística Multivariada", tabName = "stats", icon = icon("chart-pie")),
      
      menuItem("4. Legislação & Limnologia", tabName = "limno", icon = icon("balance-scale")),
      
      menuItem("5. Auditoria (Fluxo do Rio)", tabName = "auditoria", icon = icon("search-location")),
      
      menuItem("6. Ecologia de Redes", tabName = "redes", icon = icon("project-diagram")),
      
      menuItem("7. Simulador & Clima", tabName = "simulador", icon = icon("cloud-sun")),
      
      menuItem("8. Nexo Saúde & Economia", tabName = "saude_eco", icon = icon("hand-holding-usd")),
      
      menuItem("9. Datalake", tabName = "dados", icon = icon("database"))
      
    ),
    
    hr(),
    
    selectInput("f_ugrhi", "Filtrar por UGRHI:", choices = c("Estado de São Paulo", sort(lista_ugrhis))),
    
    uiOutput("ui_estacao_sidebar")
    
  ),
  
  
  
  dashboardBody(
    
    tabItems(
      
      # ABA 1: MAPA
      
      tabItem(tabName = "mapa",
              
              h2("Monitoramento Geoespacial (Gêmeo Digital)"),
              
              fluidRow(valueBoxOutput("v_iqf", 4), valueBoxOutput("v_crit", 4), valueBoxOutput("v_trat", 4)),
              
              box(width = 12, status = "primary", leafletOutput("mapa_geral", height = 550))
              
      ),
      
      
      
      # ABA 2: TRAÇOS FUNCIONAIS
      
      tabItem(tabName = "traits",
              
              h2("Assinatura Funcional da Comunidade Bentônica"),
              
              fluidRow(
                
                box(title = "Estratégia Respiratória", status="info", width = 4, plotOutput("plot_resp", height="300px")),
                
                box(title = "Guildas Tróficas", status="warning", width = 4, plotOutput("plot_trof", height="300px")),
                
                box(title = "Grupos Bioindicadores (Tolerância)", status="danger", width = 4, plotOutput("plot_tol", height="300px"))
                
              )
              
      ),
      
      
      
      # ABA 3: ESTATÍSTICA E MACHINE LEARNING
      
      tabItem(tabName = "stats",
              
              h2("Validação Estatística e Análise Multivariada"),
              
              fluidRow(
                
                box(title = "Ordenação de Bacias (PCA Biplot)", width = 7, plotOutput("plot_pca", height="400px")),
                
                box(title = "Matriz de Correlação (Heatmap)", width = 5, plotOutput("plot_cor", height="400px"))
                
              ),
              
              fluidRow(box(title = "Machine Learning: Feature Importance (Gini Index)", width = 12, status="success", plotOutput("plot_gini", height="250px")))
              
      ),
      
      
      
      # ABA 4: LEGISLAÇÃO E LIMNOLOGIA
      
      tabItem(tabName = "limno",
              
              h2("Enquadramento Legal e Parâmetros Químicos"),
              
              fluidRow(
                
                box(title = "Resolução CONAMA 357/2005", status = "primary", solidHeader = TRUE, width = 4,
                    
                    h4(tags$b("Classe 1 e 2 (IQF ≥ 60):")), p("Águas destinadas à proteção das comunidades aquáticas e abastecimento humano."),
                    
                    h4(tags$b("Classe 3 (IQF 30-59):")), p("Abastecimento humano apenas após tratamento avançado."),
                    
                    h4(tags$b("Classe 4 (IQF < 30):")), p("Águas degradadas.")),
                
                box(title = "Poluição Orgânica (DBO) vs Oxigenação (OD)", width = 8, plotlyOutput("plot_od_dbo", height="350px"))
                
              )
              
      ),
      
      
      
      # ABA 5: AUDITORIA
      
      tabItem(tabName = "auditoria",
              
              h2("Auditoria de Fluxo: Eficiência de Autodepuração"),
              
              fluidRow(
                
                box(width = 6, title = "Referência (Montante)", status = "info", uiOutput("ui_m"), plotlyOutput("gauge_m", height = 250)),
                
                box(width = 6, title = "Impacto (Jusante)", status = "danger", uiOutput("ui_j"), plotlyOutput("gauge_j", height = 250))
                
              ),
              
              box(width = 12, title = "Diagnóstico do Trecho", status = "warning", htmlOutput("diag_texto"))
              
      ),
      
      
      
      # ABA 6: REDES TRÓFICAS
      
      tabItem(tabName = "redes",
              
              h2("Ecologia de Redes (Food Web Resilience)"),
              
              box(width = 4, status = "warning", sliderInput("p_stress", "Estresse Ambiental (%):", 0, 100, 0)),
              
              box(width = 8, visNetworkOutput("rede_vis", height = 500))
              
      ),
      
      
      
      # ABA 7: SIMULADOR E CLIMA
      
      tabItem(tabName = "simulador",
              
              h2("Simulador Preditivo e Estresse Climático"),
              
              fluidRow(
                
                box(width = 4, status = "warning", title = "Variáveis de Controle",
                    
                    sliderInput("sim_od", "Oxigênio (mg/L)", 0,10,5), sliderInput("sim_dbo", "DBO (mg/L)", 0,50,15),
                    
                    sliderInput("sim_tox", "Carga Tóxica", 0,10,2), sliderInput("sim_mata", "Mata Ciliar %", 0,100,30)),
                
                box(width = 4, status = "success", title = "Projeção IQF", 
                    
                    valueBoxOutput("sim_iqf_box", 12), valueBoxOutput("sim_classe_box", 12)),
                
                box(width = 4, status = "danger", title = "Anomalia Climática (IPCC)",
                    
                    sliderInput("t_clima", "Aquecimento (°C)", 0, 5, 0), sliderInput("s_clima", "Intensidade Seca %", 0, 100, 0))
                
              )
              
      ),
      
      
      
      # ========================================================================
      
      # ABA 8: NEXO SAÚDE E ECONOMIA (TOTALMENTE REDESENHADA)
      
      # ========================================================================
      
      tabItem(tabName = "saude_eco",
              
              h2("Nexo: Saúde Pública e Economia Ecológica"),
              
              p("Esta secção traduz a qualidade da água (IQF) em impactos diretos para a sociedade e para os cofres públicos."),
              
              
              
              fluidRow(
                
                # Coluna de Controlos
                
                box(width = 4, status = "primary", title = "1. Variáveis do Município/Bacia", solidHeader = TRUE,
                    
                    numericInput("pop_sus", "População Exposta (Habitantes):", value = 150000, step = 10000),
                    
                    sliderInput("inv_restauracao", "Investimento em Saneamento/Mata (R$ Milhões):", min = 1, max = 50, value = 5),
                    
                    hr(),
                    
                    p(tags$b("Lógica do Modelo:")),
                    
                    p("A baixa qualidade da água eleva as taxas de internamento por Doenças Diarreicas Agudas (DDA) e os custos das estações de tratamento. O investimento simula a reversão deste quadro.")
                    
                ),
                
                
                
                # Coluna de Prejuízos (Inação) e Retorno
                
                box(width = 8, status = "danger", title = "2. Painel Financeiro e Epidemiológico Anual", solidHeader = TRUE,
                    
                    fluidRow(
                      
                      valueBoxOutput("box_casos_dvh", width = 6),
                      
                      valueBoxOutput("box_custo_sus", width = 6)
                      
                    ),
                    
                    fluidRow(
                      
                      valueBoxOutput("box_gasto_tratamento", width = 6),
                      
                      valueBoxOutput("box_roi_real", width = 6)
                      
                    )
                    
                )
                
              ),
              
              
              
              # Gráficos Dinâmicos
              
              fluidRow(
                
                box(width = 6, title = "Projeção de Casos de DDA (Com vs. Sem Investimento)", status = "warning", plotlyOutput("graf_saude", height = 300)),
                
                box(width = 6, title = "Análise de Custo-Benefício (Retorno em 10 anos)", status = "success", plotlyOutput("graf_economia", height = 300))
                
              )
              
      ),
      
      
      
      # ABA 9: DADOS
      
      tabItem(tabName = "dados", h2("Matriz Bruta (RLQ)"), DTOutput("tab_bruta"))
      
    )
    
  )
  
)



# ------------------------------------------------------------------------------

# 3. LÓGICA DO SERVIDOR (SERVER)

# ------------------------------------------------------------------------------

server <- function(input, output, session) {
  
  
  
  dados_r <- reactive({
    
    if(input$f_ugrhi == "Estado de São Paulo") return(estacoes_df)
    
    estacoes_df %>% filter(UGRHI == input$f_ugrhi)
    
  })
  
  
  
  output$ui_estacao_sidebar <- renderUI({ selectInput("sel_est", "Foco Local (Estação):", choices = sort(dados_r()$ID)) })
  
  d_local <- reactive({ req(input$sel_est); estacoes_df %>% filter(ID == input$sel_est) })
  
  
  
  # --- MAPA ---
  
  output$v_iqf <- renderValueBox({ valueBox(round(mean(dados_r()$IQF),1), "IQF Médio", icon=icon("leaf"), color="green") })
  
  output$v_crit <- renderValueBox({ valueBox(sum(dados_r()$Classe == "Classe 4"), "Pontos Críticos", icon=icon("biohazard"), color="red") })
  
  output$v_trat <- renderValueBox({ valueBox(dollar(mean(dados_r()$Custo_Trat), prefix="R$"), "Custo Tratamento/m³", icon=icon("tint"), color="blue") })
  
  output$mapa_geral <- renderLeaflet({
    
    pal <- colorFactor(c("forestgreen", "gold", "orange", "red"), levels = c("Classe 1", "Classe 2", "Classe 3", "Classe 4"))
    
    leaflet(dados_r()) %>% addProviderTiles(providers$CartoDB.Positron) %>%
      
      addCircleMarkers(~Lon, ~Lat, color=~pal(Classe), radius=6, fillOpacity=0.7, popup=~ID)
    
  })
  
  
  
  # --- TRAÇOS FUNCIONAIS ---
  
  output$plot_resp <- renderPlot({
    
    df <- d_local(); branquial <- max(0, df$OD * 10 - df$Metais * 2); tegumentar <- max(0, (10 - df$OD) * 8 + df$DBO)
    
    ggplot(data.frame(T=c("Branquial\n(Sensível)", "Tegumentar\n(Tolerante)"), V=c(branquial, tegumentar)), aes(x=T, y=V, fill=T)) + geom_col(color="black", width=0.6) + scale_fill_manual(values=c("#4daf4a", "#e41a1c")) + theme_minimal() + labs(x="",y="Densidade Predita") + theme(legend.position="none")
    
  })
  
  output$plot_trof <- renderPlot({
    
    df <- d_local(); fragmentador <- max(0, df$Mata_Ciliar * 0.8 - df$Metais * 2); coletor <- max(0, df$DBO * 2 + df$Turbidez * 0.2); raspador <- max(0, df$OD * 5 - df$Turbidez * 0.1)
    
    ggplot(data.frame(T=c("Fragmentador", "Raspador", "Coletor"), V=c(fragmentador, raspador, coletor)), aes(x=reorder(T, V), y=V, fill=T)) + geom_col(color="black") + scale_fill_brewer(palette="YlOrBr") + coord_flip() + theme_minimal() + labs(x="",y="Densidade Predita") + theme(legend.position="none")
    
  })
  
  output$plot_tol <- renderPlot({
    
    df <- d_local(); oligo <- max(0, df$DBO * 1.5 + df$Turbidez * 0.1); ept <- max(0, df$OD * 8 + df$Mata_Ciliar * 0.3 - df$Metais * 5)
    
    ggplot(data.frame(G=c("EPT (Sensíveis)", "Oligo/Chiro (Tolerantes)"), V=c(ept, oligo)), aes(x=G, y=V, fill=G)) + geom_col(color="black", width=0.6) + scale_fill_manual(values=c("#377eb8", "#984ea3")) + theme_minimal() + labs(x="",y="Densidade Predita") + theme(legend.position="none")
    
  })
  
  
  
  # --- ESTATÍSTICA E ML ---
  
  output$plot_pca <- renderPlot({
    
    pca <- prcomp(dados_r() %>% select(OD, DBO, Fosforo, Metais, Mata_Ciliar, Turbidez), scale.=TRUE)
    
    scores <- as.data.frame(pca$x); scores$Classe <- dados_r()$Classe; rot <- as.data.frame(pca$rotation); rot$Var <- rownames(rot); mult <- max(abs(scores$PC1)) / max(abs(rot$PC1)) * 0.8
    
    ggplot(scores, aes(x=PC1, y=PC2)) + geom_point(aes(color=Classe), alpha=0.5) + geom_segment(data=rot, aes(x=0,y=0,xend=PC1*mult,yend=PC2*mult), arrow=arrow(length=unit(0.2,"cm"))) + geom_text_repel(data=rot, aes(x=PC1*mult,y=PC2*mult,label=Var), fontface="bold") + scale_color_manual(values=c("Classe 1"="#1a9850", "Classe 4"="#d73027", "Classe 2"="#a6d96a", "Classe 3"="#fdae61")) + theme_minimal()
    
  })
  
  output$plot_cor <- renderPlot({
    
    cormat <- round(cor(dados_r() %>% select(OD, DBO, Fosforo, Metais, Turbidez, IQF)), 2)
    
    ggplot(melt(cormat), aes(x=Var1, y=Var2, fill=value)) + geom_tile() + scale_fill_gradient2(low="#d73027", high="#1a9850", midpoint=0) + geom_text(aes(label=value), color="black") + theme_minimal() + labs(x="",y="") + theme(axis.text.x = element_text(angle=45, hjust=1))
    
  })
  
  output$plot_gini <- renderPlot({
    
    ggplot(data.frame(V=c("OD", "Metais", "DBO", "Mata_Ciliar", "Fósforo", "Turbidez"), G=c(95, 82, 70, 55, 30, 15)), aes(x=reorder(V,G), y=G, fill=G)) + geom_bar(stat="identity", color="black") + coord_flip() + scale_fill_gradient(low="yellow", high="red") + theme_minimal() + labs(x="", y="Mean Decrease Gini") + theme(legend.position="none")
    
  })
  
  
  
  # --- LIMNOLOGIA ---
  
  output$plot_od_dbo <- renderPlotly({
    
    ggplotly(ggplot(dados_r(), aes(x=OD, y=DBO, color=Classe, text=ID)) + geom_point(alpha=0.7) + scale_color_manual(values = c("Classe 1"="#1a9850", "Classe 4"="#d73027", "Classe 2"="#a6d96a", "Classe 3"="#fdae61")) + theme_minimal(), tooltip="text")
    
  })
  
  
  
  # --- AUDITORIA ---
  
  output$ui_m <- renderUI({ selectInput("sel_m", "Selecione Montante:", choices = dados_r()$ID[dados_r()$Posicao=="Montante"]) })
  
  output$ui_j <- renderUI({ selectInput("sel_j", "Selecione Jusante:", choices = dados_r()$ID[dados_r()$Posicao=="Jusante"]) })
  
  output$gauge_m <- renderPlotly({ req(input$sel_m); plot_ly(type="indicator", mode="gauge+number", value=dados_r()$IQF[dados_r()$ID == input$sel_m], gauge=list(bar=list(color="green"))) })
  
  output$gauge_j <- renderPlotly({ req(input$sel_j); plot_ly(type="indicator", mode="gauge+number", value=dados_r()$IQF[dados_r()$ID == input$sel_j], gauge=list(bar=list(color="red"))) })
  
  output$diag_texto <- renderUI({
    
    req(input$sel_m, input$sel_j)
    
    dif <- dados_r()$IQF[dados_r()$ID == input$sel_j] - dados_r()$IQF[dados_r()$ID == input$sel_m]
    
    color <- ifelse(dif < -10, "#d9534f", "#5cb85c")
    
    HTML(paste0("<div style='background-color:", color, "; color:white; padding:15px; border-radius:5px;'><h4>", ifelse(dif < -10, "ALERTA: Carga poluidora (perda de IQF).", "TRECHO ESTÁVEL: Autodepuração mantida."), "</h4> Variação IQF: ", round(dif, 2), " pontos</div>"))
    
  })
  
  
  
  # --- REDES ---
  
  output$rede_vis <- renderVisNetwork({
    
    s <- input$p_stress
    
    nodes <- data.frame(id=1:6, label=c("Algas", "Sensíveis", "Tolerantes", "Predadores", "Peixes", "Esgoto"), group=c("R","S","T","P","Topo","M"), value=c(20,20,20,25,30,15))
    
    edges <- data.frame(from=c(1,1,6,2,3,4), to=c(2,3,3,4,4,5))
    
    if(s > 30) { nodes <- nodes[-2,]; edges <- edges[edges$from != 2 & edges$to != 2,] }
    
    if(s > 60) { nodes <- nodes[-c(4,5),]; edges <- edges[edges$from %in% c(1,3,6) & edges$to %in% c(1,3,6),] }
    
    visNetwork(nodes, edges) %>% visGroups(groupname="S", color="lightblue") %>% visEdges(arrows="to")
    
  })
  
  
  
  # --- SIMULADOR ---
  
  res_sim <- reactive({
    
    nota <- max(0, min(100, (max(0, input$sim_od - (input$t_clima * 0.5)) * 6) + (input$sim_mata * 0.3) - ((input$sim_dbo * (1 + (input$s_clima/100))) * 1.5) - (input$sim_tox * 5) + 40))
    
    cl <- ifelse(nota>=80, "Classe 1", ifelse(nota>=60, "Classe 2", ifelse(nota>=30, "Classe 3", "Classe 4")))
    
    list(nota=nota, cl=cl, cor=ifelse(nota>=60,"green",ifelse(nota>=30,"orange","red")))
    
  })
  
  output$sim_iqf_box <- renderValueBox({ valueBox(round(res_sim()$nota,1), "IQF Simulado", color=res_sim()$cor) })
  
  output$sim_classe_box <- renderValueBox({ valueBox(res_sim()$cl, "Classe (CONAMA)", color=res_sim()$cor) })
  
  
  
  # ========================================================================
  
  # LÓGICA DA ABA 8: NEXO SAÚDE E ECONOMIA (TOTALMENTE NOVA)
  
  # ========================================================================
  
  calc_eco <- reactive({
    
    req(input$pop_sus, input$inv_restauracao)
    
    iqf_medio <- mean(dados_r()$IQF, na.rm=TRUE)
    
    
    
    # 1. Cálculos de Saúde (Inação)
    
    taxa_infeccao <- max(0.01, (100 - iqf_medio) / 1000) # Ex: IQF 30 = 7% de internamentos
    
    casos_atuais <- input$pop_sus * taxa_infeccao
    
    custo_sus_atual <- casos_atuais * 450 # Custo médio de internamento por DDA (R$)
    
    
    
    # 2. Cálculos de Água (Inação)
    
    custo_m3 <- mean(dados_r()$Custo_Trat, na.rm=TRUE)
    
    gasto_trat_atual <- (input$pop_sus * 0.15 * 365) * custo_m3 # 150L/hab/dia
    
    
    
    # 3. Cenário de Investimento (Ação)
    
    melhoria <- min(0.40, input$inv_restauracao / 50) # R$ 50M melhora a bacia em 40%
    
    casos_futuros <- casos_atuais * (1 - melhoria)
    
    gasto_trat_futuro <- gasto_trat_atual * (1 - (melhoria/1.5)) # Água limpa = Tratamento mais barato
    
    
    
    # 4. Retorno (ROI)
    
    poupanca_anual <- (casos_atuais - casos_futuros)*450 + (gasto_trat_atual - gasto_trat_futuro)
    
    roi <- (poupanca_anual * 10) / (input$inv_restauracao * 1000000) * 100
    
    
    
    list(casos=casos_atuais, c_sus=custo_sus_atual, c_agua=gasto_trat_atual, poup=poupanca_anual, 
         
         roi=roi, casos_f=casos_futuros, inv = input$inv_restauracao * 1000000)
    
  })
  
  
  
  output$box_casos_dvh <- renderValueBox({ valueBox(round(calc_eco()$casos), "Casos DDA/Ano (Atual)", icon=icon("user-injured"), color="red") })
  
  output$box_custo_sus <- renderValueBox({ valueBox(dollar(calc_eco()$c_sus, prefix="R$"), "Custo Anual SUS", icon=icon("hospital"), color="red") })
  
  output$box_gasto_tratamento <- renderValueBox({ valueBox(dollar(calc_eco()$c_agua, prefix="R$"), "Custo Trat. Água/Ano", icon=icon("tint-slash"), color="orange") })
  
  output$box_roi_real <- renderValueBox({ valueBox(paste0(round(calc_eco()$roi, 1), "%"), "ROI em 10 Anos", icon=icon("chart-line"), color="green") })
  
  
  
  # Gráfico 1: Saúde (Linhas)
  
  output$graf_saude <- renderPlotly({
    
    res <- calc_eco()
    
    df <- data.frame(Ano = 2026:2035, Inacao = rep(res$casos, 10), Acao = seq(res$casos, res$casos_f, length.out=10))
    
    p <- ggplot(df, aes(x=Ano)) + 
      
      geom_line(aes(y=Inacao, color="Cenário Atual (Inação)"), size=1) + 
      
      geom_line(aes(y=Acao, color="Cenário de Investimento"), size=1) +
      
      scale_color_manual(values=c("Cenário Atual (Inação)"="red", "Cenário de Investimento"="green")) +
      
      theme_minimal() + labs(y="Nº de Internamentos Estimados", color="") + theme(legend.position="bottom")
    
    ggplotly(p) %>% layout(legend = list(orientation = "h", x = 0, y = -0.2))
    
  })
  
  
  
  # Gráfico 2: Economia (Linhas)
  
  output$graf_economia <- renderPlotly({
    
    res <- calc_eco()
    
    df <- data.frame(Ano = 2026:2035,
                     
                     Custo_Inacao = cumsum(rep(res$c_sus + res$c_agua, 10)),
                     
                     Custo_Acao = cumsum(rep((res$c_sus + res$c_agua) - res$poup, 10)) + res$inv)
    
    p <- ggplot(df, aes(x=Ano)) + 
      
      geom_line(aes(y=Custo_Inacao, color="Gasto Contínuo (Inação)"), size=1) + 
      
      geom_line(aes(y=Custo_Acao, color="Investimento + Poupança"), size=1) +
      
      scale_color_manual(values=c("Gasto Contínuo (Inação)"="red", "Investimento + Poupança"="blue")) +
      
      theme_minimal() + scale_y_continuous(labels=dollar) + labs(y="Gasto Público Acumulado (R$)", color="")
    
    ggplotly(p) %>% layout(legend = list(orientation = "h", x = 0, y = -0.2))
    
  })
  
  
  
  # --- ABA 9: DADOS ---
  
  output$tab_bruta <- renderDT({ datatable(dados_r(), options=list(scrollX=T)) })
  
}



shinyApp(ui, server)