import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/glass_surface.dart';
import '../widgets/vibrant_backdrop.dart';
import 'planner_screen.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthMode _mode = AuthMode.login;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = _mode == AuthMode.register;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: VibrantBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: GlassSurface(
                    radius: 34,
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _AuthHeader(),
                          const SizedBox(height: 24),
                          SegmentedButton<AuthMode>(
                            segments: const [
                              ButtonSegment(
                                value: AuthMode.login,
                                icon: Icon(Icons.account_circle_outlined),
                                label: Text('Login'),
                              ),
                              ButtonSegment(
                                value: AuthMode.register,
                                icon: Icon(Icons.person_add_alt_1_rounded),
                                label: Text('Cadastro'),
                              ),
                            ],
                            selected: {_mode},
                            onSelectionChanged: (selection) {
                              setState(() => _mode = selection.first);
                            },
                          ),
                          const SizedBox(height: 22),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: isRegister
                                ? Padding(
                                    key: const ValueKey('name-field'),
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: TextFormField(
                                      controller: _nameController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: const InputDecoration(
                                        labelText: 'Nome',
                                        prefixIcon: Icon(Icons.person_outline),
                                      ),
                                      validator: (value) {
                                        if (!isRegister) {
                                          return null;
                                        }

                                        if (value == null ||
                                            value.trim().length < 3) {
                                          return 'Informe pelo menos 3 letras.';
                                        }

                                        return null;
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('empty-name-field'),
                                  ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _hidePassword
                                    ? 'Mostrar senha'
                                    : 'Ocultar senha',
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Use no minimo 6 caracteres.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _submit,
                            icon: Icon(
                              isRegister
                                  ? Icons.person_add_alt_1_rounded
                                  : Icons.arrow_forward_rounded,
                            ),
                            label: Text(isRegister ? 'Criar conta' : 'Entrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return 'Informe um e-mail valido.';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fallbackName = _emailController.text.trim().split('@').first;
    final userName =
        _mode == AuthMode.register ? _nameController.text.trim() : fallbackName;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PlannerScreen(userName: _capitalize(userName)),
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return 'Aluno';
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.coral,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Agenda ACQA',
          style: TextStyle(
            color: palette.text,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Calendario diario com tarefas pendentes e concluidas.',
          style: TextStyle(
            color: palette.subtext,
            fontSize: 16,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
