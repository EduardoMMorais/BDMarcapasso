Notas da análise exploratória de dados
========================================

O código disponível nessa pasta obteve diversas métricas da base de dados disponibilizada e nesse documento iremos discutir as características que podem ter um maior impacto no treinamento de um sistema de aprendizagem de máquina.

Dúvidas em relação a base de dados
----------------------------------

Aqui documentamos algumas dúvidas sobre como os dados estão organizados:

- Ao contrário dos desfechos de readmissão, a divisão dos desfechos de morte não está muito clara. Por exemplo, um valor "death_hospitalar" não implica "death", mas todos os demais (death_intraop, death_readmission, death_30days, etc.) implicam. Em alguns casos, "death_readmission" é acompanhado por um desfecho específico de data (por exemplo "death_30days", "death_1year", etc.) e em outros casos, não  (para exemplos, veja os resgistros 33, 131, entre outros).
  Isso é uma possível fonte de divergência entre a análise dos desfechos de readmissão e morte. Os desfechos de readmissão foram agrupados, como pode ser visto no documento `1-processing.pdf`, mas nenhum agrupamento foi feito nos desfechos de morte

- "Dieta enteral" e "Dieta parenteral" ...

Conclusões das métricas
------------------------
- Existe uma correlação fraca entre o ano da operação e a readimissão, indicando que readmissões eram mais comuns no passado do que atualmente. É possível que isso seja um artefato da falta de dados? Por exemplo, ainda não deu tempo do paciente recente ser readmitido? (no caso de mortes essa relação é bem mais acentuada. Não parece ser um artefato)

- O campo "Tempo entre o P1 e P2" ("time_p1p2") é um ótimo preditor de readmissão, inclusive tendo sido selecionado pelos modelos de ML treinados. Porém em muitos casos ele pode ser uma "trapaça", revelando indiretamente o resultado (ainda mais considerando que o valor mediano para o número da admissão T0 é 1). Deve ser tratado com cuidado.

- A observação anterior também se aplica a características "Tempo entre P2 e P3", "P3 e P4", etc., "Número de atendimentos" e "Núm. de episódios de hospitalizações pós-procedimento"

- Como é de se esperar, existe uma forte correlação entre as variáveis de recursos hospitalares e aquelas que os sumarizam. Por exemplo, entre a variável "classe_meds_qtde" ("Quantidade de classes medicamentosas utilizadas") e aquelas que ela agrega. É preciso decidir, para cada caso, se é melhor utilizar as variáveis separadas ou agregadas (ou ambos).
  - No caso de medicamentos utilizados, o uso de DVA e diuréticos são bons indicadores de readmissão (p < 0.001), enquanto tromboliticos não são bons indicadores (p = 0.578). Isso poderia indicar que é melhor utilizar as classes medicamentosas como variáveis separadas no lugar de utilizar os valores agregados. Porém, é preciso tomar cuidado pois existe correlação entre os usos de DVA e diuréticos. Além disso, a "Quantidade de classes medicamentosas utilizadas" também parece ser um bom indicador por si só
  - A mesma situação se repete com "procedimentos invasivos" e "exames diagnóstico por imagem"
  - Não existe uma diferença tão grande entre cada um dos métodos gráficos (com possível excessão da Polissonografia). Isso sugere que usar o valor de "Quantidade de exames por métodos gráficos" de maneira agregada é mais interessante
  - A mesma situação se repete com "exames de análises clínicas" e "exames histopatológicos"
  - Existem correlações entre exames e procedimentos de classes distintas. Por exemplo, "Quantidade de exames diagnóstico por imagem", "Exames laboratoriais" e "ECG"

- Algumas variáveis categóricas tem pouquíssimos casos em certas classes. Exemplos incluem "Transplante cardíaco prévio", "Endocardite prévia" e "Hemodiálise". Alguns deles, como o "Transplante cardíaco prévio", possuem métricas que parecem indicar que são critérios relevantes readmissão (Chi-squared com p-value < 0.001), porém a baixa quantidade de casos (apenas 43 de um total de 16033) pode causar problemas de viés

- Em apenas 12,61% dos casos ouve readmissão e em 15,89% dos casos ouve morte. Isso é uma boa notícia, mas pode levar a viés no treinamento. Note que um sistema que sempre responda "não" terá em torno de 85% de acerto em ambos os casos.