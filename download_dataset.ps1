# Download e extração do dataset GTSRB
# Uso: .\download_dataset.ps1  (correr na raiz do projeto, em PowerShell)

$BASE_URL = "https://www.di.uminho.pt/~arf/storage/vcpi/gtsrb"

Write-Host "A fazer download dos datasets..."
curl.exe -L --progress-bar "$BASE_URL/train_images.zip" -o train_images.zip
curl.exe -L --progress-bar "$BASE_URL/test_images.zip"  -o test_images.zip

Write-Host "A extrair..."
Expand-Archive -Path train_images.zip -DestinationPath train -Force
Expand-Archive -Path test_images.zip  -DestinationPath test  -Force

Write-Host "A limpar zips..."
Remove-Item train_images.zip, test_images.zip

Write-Host "Concluido! Pastas criadas: train/ e test/"
