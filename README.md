# Projeto VCPI — Classificação de Sinais de Trânsito (GTSRB)

Trabalho da disciplina **Visão Computacional e Processamento de Imagem**. Fase 1 (entrega 16 maio 2026): pré-processamento de imagem e *data augmentation*.

## Resultado

Melhor modelo: **`Conv_VCPI` + `F_clahe_combo`** → **99.48 %** de *test accuracy*.

14 modelos treinados (2 arquiteturas × 7 estratégias de augmentation) — *checkpoints* em `checkpoints/`, prontos para *ensemble* na Fase 2.

## Estrutura

```
.
├── notebook.ipynb          # Notebook principal (Fase 1)
├── relatorio_fase1.md      # Relatorio
├── checkpoints/<arch>/<strategy>/best.pt   # 14 modelos treinados
├── logs/                   # Historicos JSON + tabela CSV
└── dataset_stats_48.npz    # mean/std do treino (cache)
```

## Como correr

### Pré-requisitos

```bash
pip install torch torchvision numpy pandas matplotlib seaborn scikit-learn opencv-python Pillow
```

### Dataset

O GTSRB **não está versionado** (~535 MB). Descarregar e organizar como:

```
training_images/<class_id>/*.ppm    # ex: training_images/00000/00000_00000.ppm
test_images/<class_id>/*.ppm
```

Onde `<class_id>` ∈ `{00000, 00001, ..., 00042}` (43 classes).

### Execução

```bash
jupyter notebook notebook.ipynb
# Run All — os 14 checkpoints sao detectados via SKIP_IF_DONE; a analise
# regenera todos os outputs em ~5 minutos.
```

## Fase 2

Os 14 *checkpoints* em `checkpoints/` serão a base dos *ensembles* da Fase 2 (entrega 5 junho 2026) — notebook separado a fornecer.
