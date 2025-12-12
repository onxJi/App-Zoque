import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Example widget demonstrating how to use AdMob in the app
/// This is for reference and can be integrated into any screen
class AdMobExampleWidget extends StatelessWidget {
  const AdMobExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AdMob Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Section
            Consumer<AdMobProvider>(
              builder: (context, adMobProvider, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AdMob Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Initialized: ${adMobProvider.isInitialized}'),
                        Text(
                          'Interstitial Ready: ${adMobProvider.isInterstitialAdReady}',
                        ),
                        Text(
                          'Rewarded Ready: ${adMobProvider.isRewardedAdReady}',
                        ),
                        if (adMobProvider.error != null)
                          Text(
                            'Error: ${adMobProvider.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Interstitial Ad Section
            const Text(
              'Interstitial Ads',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final adMobProvider = context.read<AdMobProvider>();
                await adMobProvider.loadInterstitialAd();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Interstitial ad loaded!')),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Load Interstitial Ad'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final adMobProvider = context.read<AdMobProvider>();
                if (adMobProvider.isInterstitialAdReady) {
                  await adMobProvider.showInterstitialAd();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ad not ready. Load it first!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Show Interstitial Ad'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final adMobProvider = context.read<AdMobProvider>();
                await adMobProvider.loadAndShowInterstitialAd();
              },
              icon: const Icon(Icons.flash_on),
              label: const Text('Load & Show Interstitial'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 16),

            // Rewarded Ad Section
            const Text(
              'Rewarded Ads',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final adMobProvider = context.read<AdMobProvider>();
                await adMobProvider.loadRewardedAd();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rewarded ad loaded!')),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Load Rewarded Ad'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final adMobProvider = context.read<AdMobProvider>();
                if (adMobProvider.isRewardedAdReady) {
                  await adMobProvider.showRewardedAd(
                    onRewarded: () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 Reward earned!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  );
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ad not ready. Load it first!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.card_giftcard),
              label: const Text('Show Rewarded Ad'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
