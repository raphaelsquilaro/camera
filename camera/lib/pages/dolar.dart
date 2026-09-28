import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dolar extends StatefulWidget {
  const Dolar({super.key});

  @override
  State<Dolar> createState() => _DolarState();
}

class _DolarState extends State<Dolar> {
  // --------------------------------------------------
  // CORES DO PROJETO
  // --------------------------------------------------
  static const Color azulEscuro = Color(0xFF283747);
  static const Color vinho = Color(0xFF472837);
  static const Color verdeEscuro = Color(0xFF374728);
  static const Color cinzaAzulado = Color(0xFF5D6D7E);

  String nome = '';
  String compra = '';
  String venda = '';
  String maxima = '';
  String minima = '';

  bool carregando = false;
  String? erro;

  // --------------------------------------------------
  // CONSULTA COTAÇÃO
  // --------------------------------------------------
  Future<void> consultar() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final url = Uri.parse(
        'https://economia.awesomeapi.com.br/last/USD-BRL',
      );

      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        throw Exception(
          'Erro na comunicação com o servidor.',
        );
      }

      final dados = jsonDecode(resposta.body);
      final dolar = dados['USDBRL'];

      setState(() {
        nome = dolar['name'] ?? 'Dólar Americano / Real Brasileiro';
        compra = dolar['bid'] ?? '--';
        venda = dolar['ask'] ?? '--';
        maxima = dolar['high'] ?? '--';
        minima = dolar['low'] ?? '--';
      });
    } catch (e) {
      setState(() {
        erro = 'Não foi possível consultar a cotação.\n'
            'Verifique sua conexão e tente novamente.';

        nome = '';
        compra = '';
        venda = '';
        maxima = '';
        minima = '';
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
          'Cotação do Dólar',
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
                  // ÍCONE DO DÓLAR
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
                      Icons.attach_money_rounded,
                      size: 58,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------------------------
                  // TÍTULO
                  // --------------------------------------------------
                  const Text(
                    'Cotação do Dólar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: azulEscuro,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Consulte a cotação atual do dólar em relação ao real.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cinzaAzulado,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // BOTÃO CONSULTAR
                  // --------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: carregando ? null : consultar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: verdeEscuro,
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
                                  Icons.refresh_rounded,
                                  size: 21,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Atualizar cotação',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
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
                  if (nome.isNotEmpty) _buildResultado(),

                  const SizedBox(height: 20),

                  // --------------------------------------------------
                  // INDICADORES DE CORES
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
            color: azulEscuro.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // --------------------------------------------------
          // CABEÇALHO
          // --------------------------------------------------
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: verdeEscuro.withOpacity(0.10),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.currency_exchange_rounded,
              color: verdeEscuro,
              size: 32,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: azulEscuro,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Valores em tempo real',
            style: TextStyle(
              fontSize: 13,
              color: cinzaAzulado,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 45,
            height: 3,
            decoration: BoxDecoration(
              color: verdeEscuro,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 22),

          // --------------------------------------------------
          // COMPRA E VENDA
          // --------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _priceCard(
                  title: 'Compra',
                  value: compra,
                  icon: Icons.arrow_downward_rounded,
                  color: azulEscuro,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _priceCard(
                  title: 'Venda',
                  value: venda,
                  icon: Icons.arrow_upward_rounded,
                  color: verdeEscuro,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------
          // MÁXIMA E MÍNIMA
          // --------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  title: 'Máxima',
                  value: maxima,
                  icon: Icons.trending_up_rounded,
                  color: verdeEscuro,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _infoCard(
                  title: 'Mínima',
                  value: minima,
                  icon: Icons.trending_down_rounded,
                  color: vinho,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // AVISO
          // --------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: cinzaAzulado.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: cinzaAzulado,
                  size: 19,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'A cotação pode variar ao longo do dia.',
                    style: TextStyle(
                      fontSize: 12,
                      color: cinzaAzulado,
                    ),
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
  // CARD DE PREÇO
  // --------------------------------------------------
  Widget _priceCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 7),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: cinzaAzulado,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'R\$ $value',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CARD DE INFORMAÇÃO
  // --------------------------------------------------
  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: cinzaAzulado,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'R\$ $value',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: color,
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