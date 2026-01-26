import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // For PDF download if we add it back

class ExperienceApp extends StatelessWidget {
  const ExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Abdisa Tsegaye',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Portfolio & Experience',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement PDF Download
                  // launchUrl(Uri.parse('path/to/resume.pdf'));
                },
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // Timeline
          const _TimelineItem(
            year: '2024 - Present',
            title: 'Senior Flutter Developer',
            company: 'Tech Innovations Inc.',
            description:
                'Leading a team of 5 developers building cross-platform apps. Implemented CI/CD pipelines and improved app performance by 40%.',
            isLast: false,
          ),
          const _TimelineItem(
            year: '2022 - 2024',
            title: 'Mobile App Developer',
            company: 'Creative Solutions',
            description:
                'Developed 3 major apps for fintech clients. Specialized in complex animations and state management with Bloc.',
            isLast: false,
          ),
          const _TimelineItem(
            year: '2020 - 2022',
            title: 'Junior Developer',
            company: 'StartUp Hub',
            description:
                'Collaborated on the MVP of a delivery app. Learned Flutter, Firebase, and Agile methodologies.',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String company;
  final String description;
  final bool isLast;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.company,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Line
          SizedBox(
            width: 80,
            child: Column(
              children: [
                Text(
                  year,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : Container(width: 2, color: Colors.grey[300]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Dot & Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, top: 4, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(description,
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
