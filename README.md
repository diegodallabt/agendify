# Agendify

Aplicativo Flutter para agendamento de postagens, com calendário e lista de posts por dia.

---

## Sumário

* [Funcionalidades](#funcionalidades)
* [Pré-requisitos](#pré-requisitos)
* [Instalação e Execução](#instalação-e-execução)
* [Arquitetura do Projeto](#arquitetura-do-projeto)

---

## Funcionalidades

* Tela de calendário que exibe quantidade de posts agendados para os dias do mês.
* Lista de postagens para o dia selecionado (cards com imagem, título, descrição, data/hora e menu “Editar/Excluir”).
* Tela de agendamento/edição de post, com carrossel de imagens aleatórias geradas com Picsum, modelo de post composto pelos campos Título, Legenda, Data e Hora.
* Persistência local das postagens usando Hive.
* Layout responsivo para celulares e tablets.
* Gerenciamento de estado via Provider (ChangeNotifier).

---

## Pré-requisitos

1. **Flutter SDK**

   * Versão mínima: `>=3.0.0`
   * Link de instalação: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

2. **Pacotes externos utilizados no projeto**
    
   * `provider`
   * `hive`
   * `hive_flutter`
   * `intl`
   * `shimmer`
   * `font_awesome_flutter`

---

## Instalação e Execução

1. **Clonar o repositório**

   ```bash
   git clone https://github.com/diegodallabt/agendify.git
   cd agendify
   ```

2. **Instalar dependências**

   ```bash
   flutter pub get
   ```

3. **Gerar adaptadores Hive**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Executar o app**

   ```bash
   flutter run
   ```

---

## Arquitetura do Projeto

Utilizei a MVVM simplificada para evitar overengineering e pra garantir separação de responsabilidades da lógica de negócio/UI.

```
lib/
├── core/
│   ├── hive/
│   │   └── hive_config.dart       # Inicializa o Hive, registra adapters e abre boxes
│   ├── theme/
│   │   ├── app_colors.dart        # Constantes de cores do app
│   │   └── app_theme.dart         # Definição de tema básico
│   └── utils/
│       ├── calendar_utils.dart    # Funções utilitárias para construção e formatação do calendário
│       └── formatter.dart         # Formatação de datas e horas
│
├── modules/
│   ├── calendar/
│   │   ├── view/
│   │   │   └── calendar_page.dart # Tela de calendário + lista de posts do dia
│   │   ├── viewmodel/
│   │   │   └── calendar_viewmodel.dart  # Lógica de seleção de datas, leitura de Hive, exclusão
│   │   └── widget/
│   │       ├── calendar.dart       # Componente de calendário (Grid de dias, navegação de mês)
│   │       ├── card.dart           # Componente de card de post (imagem, texto, data/hora, menu)
│   │       └── empty_posts.dart    # Componente para quando não há posts agendados
│   │
│   └── schedule/
│       ├── model/
│       │   └── post_model.dart     # Declaração de PostModel (HiveType/HiveObject)
│       ├── view/
│       │   └── schedule_page.dart  # Tela de agendamento/edição de posts
│       ├── viewmodel/
│       │   └── schedule_viewmodel.dart # Lógica de geração de imagens, validação e persistência
│       └── widget/
│           ├── input.dart          # Campo de texto customizado com label e placeholder
│           ├── button.dart         # Botão estilizado com loading interno
│          
```