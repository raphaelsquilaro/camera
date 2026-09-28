import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cep extends StatefulWidget {
  const Cep({super.key});

  @override
  State<Cep> createState() => _CepState();
}

class _CepState extends State<Cep> {
  // --------------------------------------------------
  // CORES DO PROJETO
  // --------------------------------------------------
  static const Color azulEscuro = Color(0xFF283747);
  static const Color vinho = Color(0xFF472837);
  static const Color verdeEscuro = Color(0xFF374728);
  static const Color cinzaAzulado = Color(0xFF5D6D7E);

  final TextEditingController cep = TextEditingController();

  String endereco = '';
  bool carregando = false;
  String? erro;

  // --------------------------------------------------
  // CONSULTA CEP
  // --------------------------------------------------
  Future<void> consultar() async {
    final cepDigitado = cep.text.replaceAll(RegExp(r'\D'), '');

    if (cepDigitado.length != 8) {
      setState(() {
        erro = 'Digite um CEP válido com 8 números.';
        endereco = '';
      });
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
      endereco = '';
    });

    try {
      final url = Uri.parse(
        'https://viacep.com.br/ws/$cepDigitado/json/',
      );

      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        throw Exception('Erro na comunicação com o servidor.');
      }

      final dados = jsonDecode(resposta.body);

      if (dados['erro'] == true) {
        setState(() {
          erro = 'CEP não encontrado.';
          endereco = '';
        });
        return;
      }

      setState(() {
        endereco =
            '${dados['logradouro'] ?? ''}\n'
            '${dados['bairro'] ?? ''}\n'
            '${dados['localidade'] ?? ''} - '
            '${dados['uf'] ?? ''}';
      });
    } catch (e) {
      setState(() {
        erro = 'Não foi possível consultar o CEP.\n'
            'Verifique sua conexão e tente novamente.';
        endereco = '';
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
  // LIMPAR
  // --------------------------------------------------
  void limpar() {
    cep.clear();

    setState(() {
      endereco = '';
      erro = null;
    });
  }

  @override
  void dispose() {
    cep.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
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
          'Consulta CEP',
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
                      color: azulEscuro,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: azulEscuro.withOpacity(0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 54,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------------------------
                  // TÍTULO
                  // --------------------------------------------------
                  const Text(
                    'Consultar endereço',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: azulEscuro,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Digite um CEP para encontrar o endereço correspondente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cinzaAzulado,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // CARD DE CONSULTA
                  // --------------------------------------------------
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CEP',
                          style: TextStyle(
                            color: azulEscuro,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 9),

                        // --------------------------------------------------
                        // CAMPO CEP
                        // --------------------------------------------------
                        TextField(
                          controller: cep,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.search,
                          maxLength: 9,
                          onSubmitted: (_) => consultar(),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '00000-000',
                            hintStyle: TextStyle(
                              color: cinzaAzulado.withOpacity(0.55),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: azulEscuro,
                            ),
                            suffixIcon: cep.text.isNotEmpty
                                ? IconButton(
                                    tooltip: 'Limpar',
                                    onPressed: limpar,
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: cinzaAzulado,
                                    ),
                                  )
                                : null,
                            filled: true,
                            fillColor: const Color(0xFFF4F5F6),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 17,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: cinzaAzulado.withOpacity(0.15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: azulEscuro,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // --------------------------------------------------
                        // BOTÃO CONSULTAR
                        // --------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: carregando ? null : consultar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulEscuro,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  cinzaAzulado.withOpacity(0.35),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: carregando
                                ? const SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_rounded,
                                        size: 21,
                                      ),
                                      SizedBox(width: 9),
                                      Text(
                                        'Consultar CEP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
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
                  // ERRO
                  // --------------------------------------------------
                  if (erro != null)
                    _buildError(),

                  // --------------------------------------------------
                  // RESULTADO
                  // --------------------------------------------------
                  if (endereco.isNotEmpty)
                    _buildResultado(),

                  const SizedBox(height: 20),

                  // --------------------------------------------------
                  // INDICADORES DAS CORES
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
  // CARD DE RESULTADO
  // --------------------------------------------------
  Widget _buildResultado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: verdeEscuro.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: verdeEscuro.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: verdeEscuro.withOpacity(0.10),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: verdeEscuro,
              size: 32,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Endereço encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: azulEscuro,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 45,
            height: 3,
            decoration: BoxDecoration(
              color: verdeEscuro,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            endereco,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: cinzaAzulado,
              height: 1.6,
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
