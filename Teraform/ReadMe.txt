## Terraform

Umieść w tym katalogu pliki konfiguracyjne Terraform (`*.tf`), a następnie wykonaj poniższe polecenia.

### 1. Inicjalizacja Terraform

```bash
terraform init
```

### 2. Odświeżenie stanu

Wykonaj tylko wtedy, gdy infrastruktura/instancja już istnieje i nie jest tworzona od zera:

```bash
terraform refresh
```

### 3. Sprawdzenie planowanych zmian

```bash
terraform plan
```

### 4. Zastosowanie konfiguracji

```bash
terraform apply -auto-approve
```

Pełna kolejność dla istniejącej infrastruktury:

```bash
terraform init
terraform refresh
terraform plan
terraform apply -auto-approve
```

Dla nowej infrastruktury:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```
