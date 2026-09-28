# 📷 Aplicativo de Câmera Flutter

Aplicativo desenvolvido em **Flutter** para captura de fotos utilizando a câmera do dispositivo e seleção de imagens diretamente da galeria.

O projeto possui uma interface simples e moderna, utilizando uma paleta de cores personalizada.

## ✨ Funcionalidades

- 📷 Visualização da câmera em tempo real
- 📸 Captura de fotos
- 🖼️ Seleção de imagens da galeria
- 🔄 Possibilidade de tirar uma nova foto
- ⏳ Indicadores de carregamento
- ⚠️ Tratamento básico de erros
- 🎨 Tema personalizado
- 📱 Interface adaptável para dispositivos móveis

## 🎨 Paleta de cores

O aplicativo utiliza as seguintes cores:

| Cor | Hexadecimal | Utilização |
|---|---|---|
| Azul escuro | `#283747` | Cor principal e AppBar |
| Vinho | `#472837` | Botão da galeria |
| Verde escuro | `#374728` | Botão de nova foto |
| Cinza azulado | `#5D6D7E` | Elementos secundários |

## 🛠️ Tecnologias utilizadas

- **Flutter**
- **Dart**
- [`camera`](https://pub.dev/packages/camera)
- [`image_picker`](https://pub.dev/packages/image_picker)

## 📦 Dependências

Adicione as seguintes dependências ao `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  camera: ^0.11.0
  image_picker: ^1.1.2
```

> As versões podem ser atualizadas conforme a versão do Flutter utilizada no projeto.

Depois de adicionar as dependências:

```bash
flutter pub get
```

## 🚀 Como executar

### 1. Clone o projeto

```bash
git clone https://github.com/seu-usuario/seu-projeto.git
```

Entre na pasta:

```bash
cd seu-projeto
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Verifique o ambiente Flutter

```bash
flutter doctor
```

### 4. Execute o aplicativo

```bash
flutter run
```

Também é possível executar em um dispositivo específico:

```bash
flutter devices
```

Depois:

```bash
flutter run -d ID_DO_DISPOSITIVO
```

## 📱 Permissões

Como o aplicativo utiliza câmera e galeria, é necessário configurar as permissões de acordo com a plataforma.

### Android

Verifique o arquivo:

```text
android/app/src/main/AndroidManifest.xml
```

Adicione, se necessário:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

O `image_picker` também pode exigir configurações adicionais dependendo da versão do Android e da estratégia utilizada pelo projeto.

### iOS

Abra:

```text
ios/Runner/Info.plist
```

Adicione as descrições necessárias:

```xml
<key>NSCameraUsageDescription</key>
<string>Este aplicativo precisa acessar a câmera para tirar fotos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Este aplicativo precisa acessar suas fotos para selecionar uma imagem.</string>
```

## 📂 Estrutura básica

```text
lib/
└── main.dart
```

Para projetos maiores, recomenda-se separar a aplicação em diferentes camadas:

```text
lib/
├── main.dart
├── screens/
│   └── camera_screen.dart
├── widgets/
│   ├── camera_preview.dart
│   └── camera_button.dart
├── services/
│   └── camera_service.dart
└── theme/
    └── app_theme.dart
```

## 📸 Fluxo do aplicativo

```text
                 ┌─────────────────┐
                 │   Inicialização │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │   Inicializa    │
                 │     câmera      │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │ CameraPreview   │
                 └───────┬─────────┘
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       ┌─────────────┐       ┌─────────────┐
       │ Tirar foto  │       │   Galeria   │
       └──────┬──────┘       └──────┬──────┘
              │                     │
              └──────────┬──────────┘
                         ▼
                  ┌─────────────┐
                  │ Exibir foto │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │ Nova foto   │
                  └─────────────┘
```

## 🧩 Principais componentes

### `CameraController`

Responsável pelo controle da câmera do dispositivo:

```dart
camera = CameraController(
  widget.camera,
  ResolutionPreset.medium,
  enableAudio: false,
);
```

O áudio é desativado porque o aplicativo trabalha apenas com captura de imagens.

### `CameraPreview`

Exibe a imagem da câmera em tempo real:

```dart
CameraPreview(camera)
```

### `takePicture()`

Captura uma imagem:

```dart
final imagem = await camera.takePicture();
```

O resultado é armazenado em um `XFile`.

### `ImagePicker`

Permite selecionar uma imagem da galeria:

```dart
final imagem = await ImagePicker().pickImage(
  source: ImageSource.gallery,
);
```

## 🎨 Tema

As cores principais ficam centralizadas no tema:

```dart
const Color corPrincipal = Color(0xFF283747);
const Color corSecundaria = Color(0xFF472837);
const Color corTerciaria = Color(0xFF374728);
const Color corCinza = Color(0xFF5D6D7E);
```

Isso facilita futuras alterações da identidade visual sem precisar procurar as cores em vários arquivos.

## ⚠️ Tratamento de erros

O aplicativo verifica situações como:

- câmera indisponível;
- erro ao inicializar a câmera;
- erro ao capturar uma foto;
- erro ao acessar a galeria;
- widget desmontado durante uma operação assíncrona.

As operações assíncronas também verificam `mounted` antes de chamar `setState()`.

## 🔒 Boas práticas utilizadas

- `WidgetsFlutterBinding.ensureInitialized()`
- `CameraController` inicializado antes do uso
- `dispose()` do controlador da câmera
- Verificação de `mounted`
- Tratamento de exceções com `try/catch`
- Estado de carregamento
- Estado de processamento
- Tema centralizado
- Separação das responsabilidades em métodos

## 🧪 Testes

Para verificar problemas no projeto:

```bash
flutter analyze
```

Para executar os testes:

```bash
flutter test
```

## 📄 Licença

Este projeto pode ser utilizado para fins de estudo e desenvolvimento.

Adicione aqui a licença escolhida para o projeto, por exemplo:

```text
MIT License
```

## 👨‍💻 Autor

Desenvolvido com Flutter e Dart.

---

⭐ Se este projeto foi útil para você, considere deixar uma estrela no repositório.
