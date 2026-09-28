import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      runApp(const CameraAppError());
      return;
    }

    runApp(
      CameraApp(camera: cameras.first),
    );
  } catch (e) {
    runApp(const CameraAppError());
  }
}

class CameraAppError extends StatelessWidget {
  const CameraAppError({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Não foi possível acessar a câmera.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CORES DO APLICATIVO
// ============================================================

const Color corPrincipal = Color(0xFF283747);
const Color corSecundaria = Color(0xFF472837);
const Color corTerciaria = Color(0xFF374728);
const Color corCinza = Color(0xFF5D6D7E);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: corPrincipal,
    primary: corPrincipal,
    secondary: corSecundaria,
    surface: Colors.white,
  ),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: corPrincipal,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: corSecundaria,
    foregroundColor: Colors.white,
  ),
);

// ============================================================
// APLICATIVO
// ============================================================

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({
    super.key,
    required this.camera,
  });

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late final CameraController camera;

  XFile? foto;

  bool carregando = true;
  bool processando = false;
  String? erro;

  @override
  void initState() {
    super.initState();
    inicializarCamera();
  }

  // ==========================================================
  // INICIALIZAÇÃO DA CÂMERA
  // ==========================================================

  Future<void> inicializarCamera() async {
    camera = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await camera.initialize();

      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = 'Erro ao iniciar a câmera.';
      });
    }
  }

  // ==========================================================
  // TIRAR FOTO
  // ==========================================================

  Future<void> tirarFoto() async {
    if (!camera.value.isInitialized || processando) return;

    setState(() {
      processando = true;
    });

    try {
      final imagem = await camera.takePicture();

      if (!mounted) return;

      setState(() {
        foto = imagem;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível tirar a foto.'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        processando = false;
      });
    }
  }

  // ==========================================================
  // NOVA FOTO
  // ==========================================================

  Future<void> abrirCamera() async {
    setState(() {
      foto = null;
    });
  }

  // ==========================================================
  // GALERIA
  // ==========================================================

  Future<void> abrirGaleria() async {
    if (processando) return;

    setState(() {
      processando = true;
    });

    try {
      final imagem = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted) return;

      if (imagem != null) {
        setState(() {
          foto = imagem;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a galeria.'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        processando = false;
      });
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: corPrincipal,
          ),
        ),
      );
    }

    if (erro != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Câmera'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 70,
                  color: corCinza,
                ),

                const SizedBox(height: 20),

                Text(
                  erro!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: corPrincipal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Câmera'),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // ÁREA DA IMAGEM
            // ==================================================

            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: corPrincipal,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: foto == null
                    ? CameraPreview(camera)
                    : Image.file(
                        File(foto!.path),
                        fit: BoxFit.contain,
                      ),
              ),
            ),

            // ==================================================
            // INDICADOR
            // ==================================================

            if (processando)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(
                  color: corTerciaria,
                ),
              ),

            // ==================================================
            // BOTÕES
            // ==================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CÂMERA / NOVA FOTO
                  FloatingActionButton.large(
                    heroTag: 'cameraButton',
                    backgroundColor: foto == null
                        ? corPrincipal
                        : corTerciaria,
                    foregroundColor: Colors.white,
                    onPressed: processando
                        ? null
                        : foto == null
                            ? tirarFoto
                            : abrirCamera,
                    child: Icon(
                      foto == null
                          ? Icons.camera_alt
                          : Icons.add_a_photo,
                    ),
                  ),

                  const SizedBox(width: 30),

                  // GALERIA
                  FloatingActionButton.large(
                    heroTag: 'galleryButton',
                    backgroundColor: corSecundaria,
                    foregroundColor: Colors.white,
                    onPressed: processando
                        ? null
                        : abrirGaleria,
                    child: const Icon(
                      Icons.photo_library,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}