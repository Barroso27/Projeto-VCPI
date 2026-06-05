# Guião de Apresentação — VCPI Trabalho 1 (GTSRB)

**Ficheiro de slides:** `apresentacao_VCPI.pptx` (16 slides)
**Duração-alvo:** ~10–12 min · **Dica:** ~30–45 s por slide de conteúdo.

---

### Slide 1 — Título
> "Boa tarde. Vou apresentar o meu trabalho de classificação de sinais de trânsito no dataset GTSRB, dividido em duas fases: primeiro *data augmentation*, depois ensembles de redes."

### Slide 2 — Agenda
> "Começo pela Fase 1 — pré-processamento, as estratégias de *augmentation* e as arquiteturas. A seguir a Fase 2, os ensembles. E fecho com as conclusões."

### Slide 3 — O problema
> "O GTSRB tem mais de 50 mil imagens reais de sinais, em **43 classes**, com resoluções muito variáveis e em condições difíceis. O objetivo é maximizar a *accuracy* no teste. O melhor resultado publicado é **99,82%**, obtido em 2012 com um ensemble de 25 redes."

### Slide 4 — Pré-processamento / CLAHE
> "Na Fase 1 comecei por comparar filtros clássicos. O que se destacou foi o **CLAHE** — equalização de histograma adaptativa com limite de contraste. Em vez de equalizar a imagem toda, fá-lo por blocos, normalizando a luminância sem amplificar ruído. Como é determinístico, apliquei-o de forma coerente em treino, validação e teste. A conclusão é que processamento de imagem clássico ainda dá ganho real em *deep learning*."

### Slide 5 — 7 estratégias de augmentation
> "Defini sete estratégias de complexidade crescente, do controlo só com *resize*, passando por *augmentation* geométrico, depois fotométrico, a combinação dos dois, depois com CLAHE e por fim com *RandomErasing*. O ponto-chave é o desenho **incremental**: cada uma acrescenta uma técnica, o que permite atribuir as variações de desempenho a componentes específicos. De propósito **não** usei *flip* horizontal — inverteria sinais direcionais — e limitei as rotações a 15 graus."

### Slide 6 — Arquiteturas e treino
> "Comparei duas arquiteturas: uma CNN (Convolutional Neural Network) própria, a **Conv_VCPI**, em estilo VGG — ou seja, blocos repetidos de convoluções pequenas, de 3×3, seguidos de *pooling*; e a **ResNet18** pré-treinada no ImageNet. Para o treino usei quatro ingredientes principais:"

- **AdamW (otimizador)** — "é o algoritmo que ajusta os pesos da rede para reduzir o erro a cada passo. É uma variante do Adam que controla melhor o tamanho dos pesos."
- **Redução do *learning rate*** — "o *learning rate* é o tamanho do passo que o otimizador dá a cada ajuste. Sempre que o erro de validação estagnava, reduzia-o para metade."
- **Early stopping** — "paro o treino automaticamente quando a validação deixa de melhorar durante algumas épocas — evita sobreajustar e poupa tempo."
- **Melhor *checkpoint*** — "ao longo do treino guardo sempre a versão da rede com menor erro de validação, não a da última época. É essa a que uso para avaliar."

*(Dica: dizer a frase de cima e depois explicar cada ponto em 1 frase, apontando para o item no slide. Se o tempo apertar, basta nomear os quatro e seguir.)*

### Slide 7 — Resultados da Fase 1
> "Nestes resultados, a 48×48, vê-se que o **CLAHE deu ganho** — comparando E com F, mais 0,26 pontos. A combinação geométrico + fotométrico + CLAHE bate qualquer técnica isolada, e o *RandomErasing* não ajudou. Curiosamente, a esta resolução a CNN própria bate a ResNet18 em **todas as 7 estratégias**. O melhor a 48×48 foi a Conv_VCPI com 99,48%."

### Slide 8 — Ablação da resolução
> "A ablação mais importante foi a resolução. A ResNet18 a 48×48 ficava atrás. Mas a **224×224**, que é a resolução nativa do ImageNet, saltou para **99,52%** e tornou-se o melhor modelo individual. Ou seja: os pesos pré-treinados só rendem perto da escala em que foram aprendidos. Já subir a Conv_VCPI para 64 não compensou, e o *weighted sampler* também não."

### Slide 9 — Conclusões da Fase 1
> "Fechei a Fase 1 com 99,52% num único modelo. Os erros que sobram são quase todos por ambiguidade visual. Notei também uma limitação do dataset — o *track leakage*: como tem sequências de fotos do mesmo sinal, a validação satura a 100% e deixa de distinguir bem os modelos. Estava perto do teto de um único modelo, e foi por isso que passei a ensembles."

### Slide 10 — Porquê ensembles
> "A ideia do ensemble é simples: modelos diversos erram em imagens diferentes, então combinar as previsões cancela erros independentes. O meu *pool* tem **17 modelos** da Fase 1. Calculei os *logits* uma vez e guardei em *cache*, por isso testar qualquer combinação é instantâneo."

### Slide 11 — Métodos de agregação
> "Testei três formas de combinar: **soft voting**, que faz a média das probabilidades e preserva a confiança de cada modelo; **weighted**, ponderado pela *accuracy* individual; e **hard voting**, voto maioritário."

### Slide 12 — Resultados da Fase 2
> "E os resultados: o melhor modelo individual estava em 99,52%, com 61 erros. O **soft voting de todos os 17 chega a 99,80%** — só 25 erros. Soft bate o weighted e o hard; o hard perde por deitar fora a informação de confiança ao reduzir cada modelo a um voto."

### Slide 13 — Saturação
> "Quis saber quantos modelos são precisos, sem fazer *cherry-picking*. Adicionei os modelos por ordem de *accuracy* individual e vi a curva. A *accuracy* **satura a partir de uns 13 modelos** — o ganho vem da diversidade das redes, não de empilhar mais."

### Slide 14 — Matriz de confusão
> "São 25 falhas no total. As duas maiores confusões são limites de velocidade parecidos — 60 trocado por 80 (classes 3→5, 5 vezes) — e dois sinais triangulares de aviso — estrada irregular trocada por obras (22→25, 5 vezes). Ou seja, os erros que restam são quase todos por **ambiguidade visual** entre sinais da mesma família."

### Slide 15 — Conclusão global
> "Em síntese, três ideias principais.
>
> Primeiro, na Fase 1, o **processamento de imagem clássico ainda importa** em deep learning: o CLAHE deu ganho real, e a melhor estratégia foi sempre a que combina *augmentation* geométrico, fotométrico e CLAHE. Um único modelo chegou a **99,52%**.
>
> Segundo, a **resolução de entrada foi decisiva** no *transfer learning* — a ResNet18 só passou à frente quando a usei a 224×224, a resolução nativa do ImageNet.
>
> E terceiro, na Fase 2, combinar redes **diversas** num ensemble por *soft voting* levou o resultado a **99,80%**— uma diferença pequena face ao melhor resultado publicado, os 99,82% do SOTA, que é também ele um ensemble.

### Slide 16 — Obrigado
> "Obrigado. Fico disponível para perguntas."

---

## Perguntas prováveis do júri (e respostas)

- **"Porque é que a ResNet18 a 48×48 perdia para uma CNN mais pequena?"**
  Porque os filtros pré-treinados do ImageNet foram aprendidos a ~224 px; a 48 px estão a ser usados fora do regime para que foram treinados. A 224, recuperam e ultrapassam.

- **"O 99,80% não está sobreajustado ao teste?"**
  Não — não selecionei nada no teste. Uso *todos* os modelos, sem escolher subconjunto. A escolha de método (soft voting) é a padrão, não foi afinada no teste.

- **"Porque não usou a validação para escolher os melhores modelos?"**
  Por causa do *track leakage*: a validação satura a 100% e não discrimina. Demonstro que selecionar pela validação piora o teste.

- **"O CLAHE é aplicado no teste?"**
  Sim. É pré-processamento determinístico, aplicado de forma idêntica em treino e teste para manter coerência.

- **"Porque não fez Test-Time Augmentation?"**
  Está identificado como trabalho futuro. O ensemble já está ao nível do SOTA; o TTA seria o passo seguinte para tentar passar.

---

## Glossário — definições dos termos técnicos

Frases curtas para usar se o júri perguntar "o que é X?". Estão por ordem temática.

### Conceitos gerais
- **GTSRB** — *German Traffic Sign Recognition Benchmark*. O dataset alemão de sinais de trânsito que usei (43 classes).
- **Accuracy** — percentagem de imagens classificadas corretamente. É a métrica que quero maximizar.
- **SOTA** (*State Of The Art*) — o melhor resultado publicado para um problema. Para o GTSRB é 99,82%.
- **Ablação** — experiência em que se muda **um só** fator de cada vez (ex.: ligar/desligar o CLAHE) para medir o efeito isolado desse fator.
- **Dataset / treino / validação / teste** — o conjunto de imagens, dividido em: **treino** (o modelo aprende), **validação** (afinar e decidir quando parar) e **teste** (avaliação final, nunca visto no treino).

### Redes e arquiteturas
- **Rede neuronal / Deep Learning** — modelo com muitas camadas que aprende padrões a partir dos dados, em vez de regras escritas à mão.
- **CNN** (*Convolutional Neural Network*) — rede convolucional; usa filtros que deslizam sobre a imagem para detetar bordas, texturas e formas. É a arquitetura-base para imagens.
- **VGG** — estilo de CNN clássico (Oxford, 2014) feito de blocos simples e repetidos: várias convoluções 3×3 seguidas de *pooling*. A minha **Conv_VCPI** segue este estilo.
- **ResNet / ResNet18** — *Residual Network* (He et al., 2016). Introduz "ligações de atalho" (*skip connections*) que somam a entrada à saída de cada bloco, permitindo treinar redes profundas sem o sinal se degradar. A **ResNet18** tem 18 camadas.
- **ImageNet** — dataset enorme (~1,2 M imagens, 1000 classes) usado para **pré-treinar** redes. A minha ResNet18 vem treinada nele.
- **Transfer learning** — reaproveitar uma rede já treinada noutro problema (ImageNet) e adaptá-la ao meu (sinais), em vez de treinar do zero.
- **Parâmetros** — os pesos que a rede aprende. Mais parâmetros = mais capacidade, mas também mais risco de *overfitting*.
- **Conv 3×3 / filtro** — pequena janela (3×3 píxeis) que percorre a imagem a calcular convoluções; é o que deteta padrões locais.
- **BatchNorm** (*Batch Normalization*) — normaliza as ativações dentro da rede; estabiliza e acelera o treino.
- **ReLU** — função de ativação (`max(0, x)`); introduz não-linearidade de forma simples e eficiente.
- **MaxPool / pooling** — reduz a resolução do mapa de características ficando com o valor máximo de cada janela; resume informação e dá robustez a pequenas translações.
- **Dropout** — durante o treino, "desliga" aleatoriamente alguns neurónios; força a rede a não depender de uns poucos e reduz o *overfitting*.
- **GAP** (*Global Average Pooling*) — em vez de "achatar" (*flatten*) todos os mapas numa camada gigante, faz a média de cada mapa. Usa menos parâmetros e generaliza melhor.

### Treino
- **Overfitting** — quando o modelo decora o treino mas falha em dados novos. As técnicas de regularização (dropout, *augmentation*) combatem-no.
- **Loss / val_loss** — a "função de custo" que o treino minimiza (erro do modelo). A **val_loss** é esse erro medido na validação.
- **AdamW** — o **otimizador**, o algoritmo que ajusta os pesos para reduzir a *loss*. É uma variante do Adam com *weight decay* (penalização de pesos grandes) corretamente separado — bom por defeito e estável.
- **Learning rate** (taxa de aprendizagem) — o tamanho do passo que o otimizador dá a cada atualização. Grande demais não converge; pequeno demais é lento.
- **ReduceLROnPlateau** — *scheduler* que **reduz o learning rate** automaticamente quando a val_loss deixa de melhorar ("estagna num plateau"), para afinar com mais precisão.
- **Early stopping** — parar o treino quando a validação deixa de melhorar durante algumas épocas, evitando *overfitting* e tempo perdido.
- **Época** (*epoch*) — uma passagem completa por todo o conjunto de treino.
- **Checkpoint** — gravação dos pesos do modelo. Guardo o **melhor** (menor val_loss), não o da última época.
- **Seed** — número que fixa a aleatoriedade (inicialização, ordem dos dados) para a experiência ser **reproduzível**.
- **Mixed precision** — treinar usando números de 16 bits em vez de 32, onde é seguro; mais rápido e usa menos memória de GPU.

### Pré-processamento e Data Augmentation
- **Data augmentation** — criar variações artificiais das imagens de treino (rodar, mudar brilho, etc.) para a rede generalizar melhor e ver mais "casos".
- **Pré-processamento** — transformações aplicadas **sempre** (treino e teste), de forma determinística (ex.: CLAHE, *resize*, normalização).
- **CLAHE** (*Contrast Limited Adaptive Histogram Equalization*) — melhora o contraste **por blocos** da imagem, com um limite que evita amplificar ruído. Ajuda em sinais mal iluminados.
- **Normalização** — pôr os píxeis numa escala padrão (média 0, desvio 1) usando a média/desvio do treino; ajuda o treino a convergir.
- **RandomAffine** — transformações geométricas aleatórias: rotação, translação, escala e *shear* (corte/inclinação).
- **RandomPerspective** — distorção de perspetiva aleatória (simula olhar o sinal de outro ângulo).
- **ColorJitter** — variação aleatória de brilho, contraste, saturação e tom (*hue*).
- **Gaussian Blur** — desfoque aleatório (simula imagens fora de foco / movimento).
- **RandomErasing / Cutout** — apaga um retângulo aleatório da imagem; força a rede a não depender de uma só zona.
- **Resolução de entrada** (ex.: 48×48, 224×224) — o tamanho a que a imagem é redimensionada antes de entrar na rede.

### Ensembles (Fase 2)
- **Ensemble** — combinar vários modelos numa só previsão; como erram em sítios diferentes, o conjunto acerta mais.
- **Logits** — as pontuações em bruto que a rede dá a cada classe, **antes** de virarem probabilidades.
- **Softmax** — função que converte os *logits* em probabilidades (somam 1).
- **Soft voting** — média das **probabilidades** softmax dos modelos; preserva a confiança de cada um. Foi o meu melhor método.
- **Weighted voting** — *soft voting* mas com cada modelo a pesar conforme a sua *accuracy*.
- **Hard voting** — cada modelo dá **um voto** (a sua classe favorita); ganha a mais votada. Perde por descartar a confiança.
- **Cache de logits** — guardar os *logits* já calculados em disco, para testar combinações de ensemble instantaneamente sem voltar a correr as redes.
- **Saturação** — a partir de certo nº de modelos, adicionar mais já não melhora a *accuracy*.

### Problemas e trabalho futuro
- **Track leakage** — o GTSRB tem sequências (*tracks*) de ~30 fotos do mesmo sinal físico, quase idênticas. Se um *split* aleatório puser fotos do mesmo *track* em treino e validação, a validação fica artificialmente perfeita (≈100%) e deixa de distinguir modelos.
- **Cherry-picking** — escolher resultados/modelos a posteriori para inflacionar a métrica; evitei-o usando **todos** os 17 modelos.
