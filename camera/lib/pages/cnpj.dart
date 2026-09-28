import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cnpj extends StatefulWidget {
  const Cnpj({super.key});

  @override
  State<Cnpj> createState() => _CnpjState();
}

class _CnpjState extends State<Cnpj> {
  // --------------------------------------------------
  // CORES DO PROJETO
  // --------------------------------------------------
  static const Color azulEscuro = Color(0xFF283747);
  static const Color vinho = Color(0xFF472837);
  static const Color verdeEscuro = Color(0xFF374728);
  static const Color cinzaAzulado = Color(0xFF5D6D7E);

  final TextEditingController cnpj = TextEditingController();

  String empresa = '';
  bool carregando = false;
  String? erro;

  // --------------------------------------------------
  // CONSULTA CNPJ
  // --------------------------------------------------
  Future<void> consultar() async {
    final cnpjDigitado = cnpj.text.replaceAll(RegExp(r'\D'), '');

    if (cnpjDigitado.length != 14) {
      setState(() {
        erro = 'Digite um CNPJ válido com 14 números.';
        empresa = '';
      });
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
      empresa = '';
    });

    try {
      final url = Uri.parse(
        'https://api.opencnpj.org/$cnpjDigitado',
      );

      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        throw Exception(
          'Erro na comunicação com o servidor.',
        );
      }

      final dados = jsonDecode(resposta.body);

      setState(() {
        empresa =
            '${dados['razao_social'] ?? 'Não informado'}\n'
            '${dados['nome_fantasia'] ?? 'Não informado'}\n'
            '${dados['situacao_cadastral'] ?? 'Não informado'}';
      });
    } catch (e) {
      setState(() {
        erro = 'Não foi possível consultar o CNPJ.\n'
            'Verifique o número e sua conexão.';
        empresa = '';
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
    cnpj.clear();

    setState(() {
      empresa = '';
      erro = null;
    });
  }

  @override
  void dispose() {
    cnpj.dispose();
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
          'Consulta CNPJ',
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
                      color: vinho,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: vinho.withOpacity(0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------------------------
                  // TÍTULO
                  // --------------------------------------------------
                  const Text(
                    'Consultar empresa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: azulEscuro,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Digite um CNPJ para consultar os dados da empresa.',
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
                          'CNPJ',
                          style: TextStyle(
                            color: azulEscuro,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 9),

                        // --------------------------------------------------
                        // CAMPO CNPJ
                        // --------------------------------------------------
                        TextField(
                          controller: cnpj,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.search,
                          maxLength: 18,
                          onChanged: (_) {
                            setState(() {});
                          },
                          onSubmitted: (_) => consultar(),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '00.000.000/0000-00',
                            hintStyle: TextStyle(
                              color: cinzaAzulado.withOpacity(0.55),
                            ),
                            prefixIcon: const Icon(
                              Icons.business_outlined,
                              color: vinho,
                            ),
                            suffixIcon: cnpj.text.isNotEmpty
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
                            contentPadding:
                                const EdgeInsets.symmetric(
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
                                color: vinho,
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
                              backgroundColor: vinho,
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
                                        'Consultar CNPJ',
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
                  if (erro != null) _buildError(),

                  // --------------------------------------------------
                  // RESULTADO
                  // --------------------------------------------------
                  if (empresa.isNotEmpty) _buildResultado(),

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
  // CARD DE RESULTADO
  // --------------------------------------------------
  Widget _buildResultado() {
    final dados = empresa.split('\n');

    final razaoSocial =
        dados.isNotEmpty ? dados[0] : 'Não informado';

    final nomeFantasia =
        dados.length > 1 ? dados[1] : 'Não informado';

    final situacao =
        dados.length > 2 ? dados[2] : 'Não informado';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
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
          ),

          const SizedBox(height: 15),

          const Center(
            child: Text(
              'Empresa encontrada',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: azulEscuro,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Container(
              width: 45,
              height: 3,
              decoration: BoxDecoration(
                color: verdeEscuro,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 22),

          _infoItem(
            icon: Icons.business_rounded,
            label: 'Razão Social',
            value: razaoSocial,
          ),

          const SizedBox(height: 16),

          _infoItem(
            icon: Icons.storefront_rounded,
            label: 'Nome Fantasia',
            value: nomeFantasia,
          ),

          const SizedBox(height: 16),

          _infoItem(
            icon: Icons.verified_rounded,
            label: 'Situação Cadastral',
            value: situacao,
            valueColor: verdeEscuro,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // ITEM DE INFORMAÇÃO
  // --------------------------------------------------
  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = cinzaAzulado,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: azulEscuro.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: azulEscuro,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
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