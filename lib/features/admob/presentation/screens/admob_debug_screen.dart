import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:appzoque/features/admob/config/admob_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Pantalla de debug para AdMob
/// Muestra el estado actual, logs y permite probar anuncios
class AdMobDebugScreen extends StatelessWidget {
  const AdMobDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdMobProvider>().clearLogs();
            },
            tooltip: 'Limpiar logs',
          ),
        ],
      ),
      body: Consumer<AdMobProvider>(
        builder: (context, adMobProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Estado General
              _buildSection(
                context,
                'Estado General',
                Icons.info_outline,
                Colors.blue,
                [
                  _buildInfoRow('Modo', adMobProvider.currentMode),
                  _buildInfoRow(
                    'SDK Inicializado',
                    adMobProvider.isInitialized ? '✅ Sí' : '❌ No',
                  ),
                  _buildInfoRow(
                    'Último Log',
                    adMobProvider.lastLog.isEmpty
                        ? 'Sin logs'
                        : adMobProvider.lastLog,
                  ),
                  if (adMobProvider.error != null)
                    _buildInfoRow('Error', adMobProvider.error!, isError: true),
                ],
              ),
              const SizedBox(height: 16),

              // Configuración
              _buildSection(
                context,
                'Configuración',
                Icons.settings,
                Colors.orange,
                [
                  _buildCopyableRow(
                    context,
                    'Interstitial ID',
                    adMobProvider.currentAdUnitId,
                  ),
                  _buildCopyableRow(
                    context,
                    'Rewarded ID',
                    AdMobConfig.rewardedAdUnitId,
                  ),
                  _buildInfoRow(
                    'Usando IDs de',
                    AdMobConfig.isTestMode ? 'PRUEBA' : 'PRODUCCIÓN',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Estado de Anuncios
              _buildSection(
                context,
                'Estado de Anuncios',
                Icons.ad_units,
                Colors.green,
                [
                  _buildInfoRow(
                    'Intersticial',
                    adMobProvider.isInterstitialAdReady
                        ? '✅ Listo'
                        : '❌ No listo',
                  ),
                  _buildInfoRow(
                    'Recompensado',
                    adMobProvider.isRewardedAdReady ? '✅ Listo' : '❌ No listo',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Acciones
              _buildSection(
                context,
                'Acciones de Prueba',
                Icons.play_arrow,
                Colors.purple,
                [
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await adMobProvider.loadInterstitialAd();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Cargar Intersticial'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: adMobProvider.isInterstitialAdReady
                        ? () async {
                            await adMobProvider.showInterstitialAd();
                          }
                        : null,
                    icon: const Icon(Icons.play_circle),
                    label: const Text('Mostrar Intersticial'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await adMobProvider.loadAndShowInterstitialAd();
                    },
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Cargar y Mostrar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await adMobProvider.loadRewardedAd();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Cargar Recompensado'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: adMobProvider.isRewardedAdReady
                        ? () async {
                            await adMobProvider.showRewardedAd(
                              onRewarded: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🎉 ¡Recompensa ganada!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text('Mostrar Recompensado'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Logs
              _buildSection(
                context,
                'Logs (${adMobProvider.logs.length})',
                Icons.list,
                Colors.grey,
                [
                  const SizedBox(height: 8),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: adMobProvider.logs.isEmpty
                        ? const Center(
                            child: Text(
                              'Sin logs',
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: adMobProvider.logs.length,
                            itemBuilder: (context, index) {
                              final log = adMobProvider
                                  .logs[adMobProvider.logs.length - 1 - index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    color: log.contains('❌')
                                        ? Colors.red
                                        : log.contains('✅')
                                        ? Colors.green
                                        : log.contains('⚠️')
                                        ? Colors.orange
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Información Importante
              _buildImportantInfo(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: isError ? Colors.red : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$label copiado')));
            },
            tooltip: 'Copiar',
          ),
        ],
      ),
    );
  }

  Widget _buildImportantInfo(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Información Importante',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              '• Los anuncios de PRODUCCIÓN pueden tardar horas o días en aparecer después de crear las unidades.',
            ),
            _buildBulletPoint(
              '• Los anuncios de PRUEBA aparecen inmediatamente.',
            ),
            _buildBulletPoint(
              '• Si no ves anuncios en producción, espera 24-48 horas.',
            ),
            _buildBulletPoint(
              '• Verifica que los IDs sean correctos en AdMob Console.',
            ),
            _buildBulletPoint('• Asegúrate de tener conexión a internet.'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}
