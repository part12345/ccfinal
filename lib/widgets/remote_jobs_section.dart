import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/remote_jobs_service.dart';

class RemoteJobsSection extends StatefulWidget {
  const RemoteJobsSection({super.key});
  @override
  State<RemoteJobsSection> createState() => _RemoteJobsSectionState();
}

class _RemoteJobsSectionState extends State<RemoteJobsSection> {
  late Future<List<RemoteJob>> _jobs;
  @override
  void initState() { super.initState(); _jobs = RemoteJobsService.fetchJobs(); }
  void _retry() => setState(() { _jobs = RemoteJobsService.fetchJobs(); });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Explore Remote Jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('Live listings loaded from the Remotive API', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 10),
      FutureBuilder<List<RemoteJob>>(
        future: _jobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Loading remote jobs...')]))));
          }
          if (snapshot.hasError) {
            return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(Icons.wifi_off, size: 32), const SizedBox(height: 8), Text('Could not load remote jobs', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text('Check your internet connection and try again.', textAlign: TextAlign.center), const SizedBox(height: 8), OutlinedButton.icon(onPressed: _retry, icon: Icon(Icons.refresh), label: Text('Retry'))])));
          }
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No remote jobs are available right now.')));
          return Column(children: jobs.take(5).map((job) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(Icons.work_outline, color: Theme.of(context).colorScheme.primary)),
              title: Text(job.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text('${job.company} • ${job.location}', maxLines: 2, overflow: TextOverflow.ellipsis)),
              trailing: Icon(Icons.public, size: 18),
              onTap: () => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
                title: Text(job.title),
                content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(job.company, style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(job.location), const SizedBox(height: 12), Text('Job details are provided by Remotive. Use the original listing to review the full description and application requirements.')])),
                actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Close')), if (job.url.isNotEmpty) TextButton(onPressed: () async { final uri = Uri.tryParse(job.url); if (uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication)) { if (dialogContext.mounted) Navigator.pop(dialogContext); } else if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to open this job listing.'))); } }, child: Text('Open listing'))],
              )),
            ),
          )).toList());
        },
      ),
    ]),
  );
}
