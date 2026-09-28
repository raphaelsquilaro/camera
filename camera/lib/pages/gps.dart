import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Gps extends StatefulWidget {
  const Gps({super.key});

  @override
  State<Gps> createState() => _GpsState();
}

class _GpsState extends State<Gps> {
  // --------------------------------------------------
  // CORES DO PROJETO
  // --------------------------------------------------
  static const Color azulEscuro = Color(0xFF283747);
  static const Color vinho = Color(0xFF472837);
  static const Color verdeEscuro = Color(0xFF374728);
  static const Color cinzaAzulado = Color(0xFF5D6D7E);

  String latitude = '';
  String longitude = '';

  bool carregando = false;
  String? erro;

  // --------------------------------------------------
  // BUSCAR LOCALIZAÇÃO
  // --------------------------------------------------
  Future<void> buscarLocalizacao() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      // Verifica se o serviço de localização está ativado.
      final servicoAtivado =
          await Geolocator.isLocationServiceEnabled();

      if (!servicoAtivado) {
        setState(() {
          erro =
              'O serviço de localização está desativado.\n'
              'Ative o GPS do dispositivo e tente novamente.';
          latitude = '';
          longitude = '';
        });
        return;
      }

      // Verifica a permissão atual.
      LocationPermission permissao =
          await Geolocator.checkPermission();

      // Solicita permissão caso ainda não tenha sido concedida.
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      // Usuário negou a permissão.
      if (permissao == LocationPermission.denied) {
        setState(() {
          erro =
              'Permissão de localização negada.\n'
              'Permita o acesso à localização para continuar.';
          latitude = '';
          longitude = '';
        });
        return;
      }

      // Permissão negada permanentemente.
      if (permissao == LocationPermission.deniedForever) {
        setState(() {
          erro =
              'A permissão de localização foi bloqueada.\n'
              'Ative a permissão nas configurações do aplicativo.';
          latitude = '';
          longitude = '';
        });
        return;
      }

      // Busca a posição atual.
      final Position posicao =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Atualiza os dados na tela.
      setState(() {
        latitude = posicao.latitude.toStringAsFixed(6);
        longitude = posicao.longitude.toStringAsFixed(6);
        erro = null;
      });
    } catch (e) {
      setState(() {
        erro =
            'Não foi possível obter sua localização.\n'
            'Tente novamente.';
        latitude = '';
        longitude = '';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final possuiLocalizacao =
        latitude.isNotEmpty && longitude.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: azulEscuro,
        foregroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: const Text(
          'Minha Localização',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // --------------------------------------------------
                  // ÍCONE
                  // --------------------------------------------------
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: verdeEscuro,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: verdeEscuro.withOpacity(0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------------------------
                  // TÍTULO
                  // --------------------------------------------------
                  const Text(
                    'Minha localização',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: azulEscuro,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Obtenha as coordenadas da localização atual '
                    'do dispositivo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cinzaAzulado,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // CARD DE LOCALIZAÇÃO
                  // --------------------------------------------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: cinzaAzulado.withOpacity(0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: azulEscuro.withOpacity(0.07),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // --------------------------------------------------
                        // LATITUDE
                        // --------------------------------------------------
                        _coordinateCard(
                          icon: Icons.north_rounded,
                          title: 'Latitude',
                          value: latitude.isEmpty
                              ? 'Aguardando localização...'
                              : latitude,
                        ),

                        const SizedBox(height: 12),

                        // --------------------------------------------------
                        // LONGITUDE
                        // --------------------------------------------------
                        _coordinateCard(
                          icon: Icons.east_rounded,
                          title: 'Longitude',
                          value: longitude.isEmpty
                              ? 'Aguardando localização...'
                              : longitude,
                        ),

                        const SizedBox(height: 20),

                        // --------------------------------------------------
                        // BOTÃO
                        // --------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                carregando ? null : buscarLocalizacao,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: verdeEscuro,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  cinzaAzulado.withOpacity(0.35),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                            child: carregando
                                ? const SizedBox(
                                    width: 23,
                                    height: 23,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_searching_rounded,
                                        size: 21,
                                      ),
                                      SizedBox(width: 9),
                                      Text(
                                        'Obter localização',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --------------------------------------------------
                  // RESULTADO ENCONTRADO
                  // --------------------------------------------------
                  if (possuiLocalizacao) _buildSucesso(),

                  // --------------------------------------------------
                  // ERRO
                  // --------------------------------------------------
                  if (erro != null) _buildError(),

                  const SizedBox(height: 20),

                  // --------------------------------------------------
                  // PALETA
                  // --------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _colorIndicator(azulEscuro),
                      const SizedBox(width: 7),
                      _colorIndicator(vinho),
                      const SizedBox(width: 7),
                      _colorIndicator(verdeEscuro),
                      const SizedBox(width: 7),
                      _colorIndicator(cinzaAzulado),
                    ],
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CARD DE COORDENADA
  // --------------------------------------------------
  Widget _coordinateCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final aguardando = value == 'Aguardando localização...';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: verdeEscuro.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: verdeEscuro,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cinzaAzulado,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: aguardando ? 13 : 17,
                    fontWeight: FontWeight.w700,
                    color: aguardando
                        ? cinzaAzulado
                        : azulEscuro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CARD DE SUCESSO
  // --------------------------------------------------
  Widget _buildSucesso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: verdeEscuro.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: verdeEscuro.withOpacity(0.20),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: verdeEscuro,
            size: 25,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              'Localização obtida com sucesso.',
              style: TextStyle(
                color: verdeEscuro,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CARD DE ERRO
  // --------------------------------------------------
  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: vinho.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: vinho.withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: vinho,
            size: 25,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              erro!,
              style: const TextStyle(
                color: vinho,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // INDICADOR DE COR
  // --------------------------------------------------
  Widget _colorIndicator(Color color) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}