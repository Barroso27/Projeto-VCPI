# Projeto VCPI — Classificação de Sinais de Trânsito (GTSRB)

Trabalho da disciplina **Visão Computacional e Processamento de Imagem**, com as duas fases reunidas num só notebook:
- **Fase 1** — pré-processamento de imagem e *data augmentation* (treino de 14 modelos).
- **Fase 2** — ensembles das redes treinadas na Fase 1.

## Resultados

- **Fase 1** — melhor modelo individual: `Conv_VCPI + F_clahe_combo` → **99.48 %** de *test accuracy* (a 48×48). O `ResNet18` a 224×224 atinge 99.52 %.
- **Fase 2** — ensemble de todos os modelos (soft voting) → **99.80 %**, ao nível do estado da arte reportado para o GTSRB (~99.82 %).

## Estrutura

```
.
├── notebook.ipynb          # Notebook único (Fase 1 + Fase 2)
├── guiao_apresentacao.md   # Guião de apresentação
├── checkpoints/<arch>/<strategy>/best.pt   # 17 modelos treinados
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
# Run All — os checkpoints são detectados via SKIP_IF_DONE (não re-treina);
# a Fase 2 usa cache de logits. A análise regenera os outputs em poucos minutos.
```
