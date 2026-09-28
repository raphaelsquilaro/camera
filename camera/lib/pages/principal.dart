import 'package:flutter/material.dart';
import 'package:foto/pages/cep.dart';
import 'package:foto/pages/cnpj.dart';
import 'package:foto/pages/dolar.dart';
import 'package:foto/pages/gps.dart';
import 'package:foto/pages/login.dart';
import 'package:foto/pages/trabalho.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // Paleta principal
  static const Color azulEscuro = Color(0xFF283747);
  static const Color vinho = Color(0xFF472837);
  static const Color verdeEscuro = Color(0xFF374728);
  static const Color cinzaAzulado = Color(0xFF5D6D7E);

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
        title: const Text(
          'Principal',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),

      // --------------------------------------------------
      // DRAWER
      // --------------------------------------------------
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cabeçalho
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 30),
                decoration: const BoxDecoration(
                  color: azulEscuro,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cinzaAzulado,
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 38,
                        backgroundColor: cinzaAzulado,
                        child: Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'MENU PRINCIPAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Selecione uma opção',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.70),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Principal
              _menuItem(
                context: context,
                icon: Icons.home_rounded,
                title: 'Principal',
                color: azulEscuro,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Trabalho
              _menuItem(
                context: context,
                icon: Icons.work_rounded,
                title: 'Trabalho',
                color: verdeEscuro,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Trabalho(),
                    ),
                  );
                },
              ),

              // CEP
              _menuItem(
                context: context,
                icon: Icons.location_on_rounded,
                title: 'CEP',
                color: azulEscuro,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cep(),
                    ),
                  );
                },
              ),

              // CNPJ
              _menuItem(
                context: context,
                icon: Icons.business_rounded,
                title: 'CNPJ',
                color: vinho,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cnpj(),
                    ),
                  );
                },
              ),

              // Dólar
              _menuItem(
                context: context,
                icon: Icons.attach_money_rounded,
                title: 'Dólar',
                color: verdeEscuro,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dolar(),
                    ),
                  );
                },
              ),

              // Geolocalização
              _menuItem(
                context: context,
                icon: Icons.my_location_rounded,
                title: 'Geolocalização',
                color: cinzaAzulado,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Gps(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Separador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: cinzaAzulado.withOpacity(0.20),
                ),
              ),

              // Logout
              _menuItem(
                context: context,
                icon: Icons.logout_rounded,
                title: 'Sair',
                color: vinho,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card principal
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 38,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: cinzaAzulado.withOpacity(0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: azulEscuro.withOpacity(0.08),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Ícone
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: azulEscuro,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: azulEscuro.withOpacity(0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Título
                    const Text(
                      'Tela Principal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: azulEscuro,
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtítulo
                    const Text(
                      'Bem-vindo ao sistema!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: cinzaAzulado,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Linha decorativa
                    Container(
                      width: 55,
                      height: 4,
                      decoration: BoxDecoration(
                        color: verdeEscuro,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Descrição
                    const Text(
                      'Utilize o menu lateral para acessar '
                      'as ferramentas disponíveis no sistema.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: cinzaAzulado,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Indicador inferior
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
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // ITEM DO MENU
  // --------------------------------------------------
  static Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: azulEscuro,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: cinzaAzulado.withOpacity(0.55),
        ),
        onTap: onTap,
      ),
    );
  }

  // --------------------------------------------------
  // INDICADOR DE COR
  // --------------------------------------------------
  static Widget _colorIndicator(Color color) {
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
