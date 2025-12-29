// providers/braj_darshan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/temple_model.dart';

class BrajDarshanNotifier extends StateNotifier<BrajDarshanState> {
  BrajDarshanNotifier() : super(const BrajDarshanState()) {
    _initializeData();
  }

  void _initializeData() {
    final temples = _getTempleData();
    final tourGuides = _getTourGuideData();

    state = state.copyWith(
      temples: temples,
      tourGuides: tourGuides,
      isLoading: false,
    );
  }

  List<Temple> _getTempleData() {
    return [
      Temple(
        id: '1',
        name: 'Shree Banke Bihari Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The Shree Banke Bihari Temple is a revered Hindu temple dedicated to Lord Krishna and Radha, and is one of the most sacred temples in the Braj region.',
        history:
            'Built in 1864 by Swami Haridas, a prominent saint and musician.',
        builtYear: '1864',
        features: [
          'Intricate Architecture',
          'Beautiful Gardens',
          'Peaceful Atmosphere',
          'Traditional and Modern Blend',
        ],
        festivals: ['Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Respect Temple Rules',
          'Be Prepared for Crowds',
          'Take Time to Explore',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
        rating: 4.8,
        reviewCount: 2500,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],

        significance: 'Divine Deity representation of Krishna and Radha',
      ),
      Temple(
        id: '2',
        name: 'Shree Radha Ballabh Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The Shree Radha Ballabh Temple is dedicated to Lord Krishna and Radha, emphasizing the divine love between them.',
        history:
            'The temple has a rich history dating back to the 16th century.',
        builtYear: '16th Century',
        features: [
          'Beautiful Deity',
          'Peaceful Atmosphere',
          'Spiritual Retreats',
          'Divine Love Emphasis',
        ],
        festivals: ['Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Perfect for Spiritual Meditation',
          'Carry Water',
          'Respect Sacred Atmosphere',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1492195536/photo/prem-mandir-is-a-hindu-temple-dedicated-to-shri-radha-krishna-located-in-the-holy-city-of.jpg?s=612x612&w=0&k=20&c=AHaD8DYIirhtpb5mwLoxcX6I719445vPFR_7yAC29bU=',
        rating: 4.6,
        reviewCount: 1800,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Divine Love between Radha and Krishna',
      ),
      Temple(
        id: '3',
        name: 'Shree Radha Raman Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The Shree Radha Raman Temple is dedicated to Lord Krishna in the form of Radha Raman, built by Gopal Bhatt Goswami.',
        history:
            'Built in 16th century by Gopal Bhatt Goswami, a prominent disciple of Chaitanya Mahaprabhu.',
        builtYear: '16th Century',
        features: [
          'Self-manifested Deity',
          'Beautiful Architecture',
          'Intricate Carvings',
          'Traditional Design',
        ],
        festivals: ['Holi', 'Janmashtami', 'Govardhan Puja'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Visit During Aarti',
          'Photography Restrictions',
          'Maintain Silence',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
        rating: 4.7,
        reviewCount: 2200,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Self-manifested deity of Lord Krishna',
      ),
      Temple(
        id: '4',
        name: 'Shree Nidhivan',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'Nidhivan is a sacred place in Vrindavan, associated with Lord Krishna’s divine pastimes. It’s believed to be the site where Krishna and Radha performed their Raslila.',
        history: 'A historic sacred grove with origins tied to Krishna’s era.',
        builtYear: 'Ancient',
        features: [
          'Temples and Shrines',
          'Peaceful Atmosphere',
          'Sacred Trees',
          'Spiritual Contemplation',
        ],
        festivals: ['Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Throughout the day',
        entryFee: 'Free',
        tips: [
          'Respect Sacred Atmosphere',
          'Avoid Visiting After Sunset',
          'Dress Modestly',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        rating: 4.9,
        reviewCount: 3000,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Site of Krishna and Radha’s divine Raslila dance',
      ),
      Temple(
        id: '5',
        name: 'Keshi Ghat',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'Keshi Ghat is a sacred ghat on the banks of the Yamuna River, associated with Lord Krishna’s divine pastimes where he defeated the demon Keshi.',
        history:
            'A historic site linked to Krishna’s victory over the demon Keshi.',
        builtYear: 'Ancient',
        features: [
          'Temples and Shrines',
          'Yamuna River Views',
          'Sunrise and Sunset Spots',
          'Holy Dip Sites',
        ],
        festivals: ['Holi', 'Kartik Purnima', 'Janmashtami'],
        timings: 'Throughout the day',
        entryFee: 'Free',
        tips: [
          'Respect Sanctity of Ghat',
          'Ideal for Morning Visits',
          'Follow Local Guidelines',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1206473180/photo/keshi-ghat-krishna-temple-vrindavan.jpg?s=612x612&w=0&k=20&c=QOkkUng84dP1q7gosIjPgOavKol7tkzRwcySoeXQCU8=',
        rating: 4.5,
        reviewCount: 1500,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Site where Krishna defeated the demon Keshi',
      ),
      Temple(
        id: '6',
        name: 'Shree Rang Nath Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The Shree Rang Nath Temple is a revered Hindu temple dedicated to Lord Krishna in the form of Rang Nath, a significant pilgrimage site.',
        history:
            'A historic temple with roots in Vrindavan’s spiritual heritage.',
        builtYear: 'Unknown',
        features: [
          'Beautiful Deity',
          'Intricate Architecture',
          'Peaceful Atmosphere',
          'Spiritual Retreats',
        ],
        festivals: ['Holi', 'Janmashtami', 'Rath Yatra'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Follow Dress Code',
          'Attend Evening Aarti',
          'Explore Temple Complex',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1305636586/photo/closeup-of-shiva-temple-a-symbol-or-icon-of-hindu-god-shiva-used-to-perform-puja-or-prayers.jpg?s=612x612&w=0&k=20&c=Q00qVYpu7YMfKM8eZQKPajfQK0ZsAMAijFueliyso44=',
        rating: 4.6,
        reviewCount: 2000,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Significant pilgrimage site for Krishna devotees',
      ),
      Temple(
        id: '7',
        name: 'Shree Radha Madan Mohan Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The Shree Radha Madan Mohan Temple is one of the oldest and most sacred temples in the Braj region, dedicated to Lord Krishna and Radha.',
        history:
            'Built in the 16th century by Sanatana Goswami, a prominent disciple of Chaitanya Mahaprabhu.',
        builtYear: '16th Century',
        features: [
          'Beautiful Deity',
          'Intricate Architecture',
          'Peaceful Atmosphere',
          'Traditional Design',
        ],
        festivals: ['Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Respect Temple Rules',
          'Be Prepared for Crowds',
          'Take Time to Explore',
          'Photography Restrictions',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2161154260/photo/view-of-the-ashram-temple-from-shri-radha-madan-mohan-temple-vrindavan-mathura-uttar-pradesh.jpg?s=612x612&w=0&k=20&c=XqFucfETz_PgDBciuoby4YWXOnrSQf4S9HCzBx5eS5g=',
        rating: 4.8,
        reviewCount: 2300,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Sacred temple with historical deity from Rajasthan',
      ),
      Temple(
        id: '8',
        name: 'ISKCON Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'The ISKCON Temple in Vrindavan is a prominent spiritual center dedicated to Lord Krishna and Radha, known for its vibrant spiritual activities.',
        history:
            'Established by ISKCON, founded by Srila Prabhupada in the 20th century.',
        builtYear: '1975',
        features: [
          'Beautiful Deities',
          'Spiritual Programs',
          'Vibrant Festivals',
          'Volunteer Opportunities',
        ],
        festivals: ['Janmashtami', 'Radhastami', 'Gaura Purnima'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Participate in Kirtans',
          'Try Prasadam',
          'Attend Spiritual Discourses',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1145437356/photo/sri-radha-krishna-iskcon-temple.jpg?s=612x612&w=0&k=20&c=6HaubYGAx5MTapPFKrmJT39LMPPFDws01V-tsDRSIww=',
        rating: 4.9,
        reviewCount: 3500,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Prominent center for Krishna consciousness',
      ),
      Temple(
        id: '9',
        name: 'Prem Mandir',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'Prem Mandir is a stunning temple complex dedicated to Lord Krishna and Radha, known for its breathtaking architecture and serene atmosphere.',
        history: 'Founded by Jagadguru Kripaluji Maharaj in 2012.',
        builtYear: '2012',
        features: [
          'Exquisite Architecture',
          'Beautiful Gardens',
          'Evening Aarti',
          'Intricate Stone Work',
        ],
        festivals: ['Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Visit During Evening Aarti',
          'Explore Gardens',
          'Dress Modestly',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2171891587/photo/prem-mandir-krishna-temple-vrindavan.jpg?s=612x612&w=0&k=20&c=PsCS__3uA1vgzm9p15WxeQsKcNNBKd7zwoYWik78II4=',
        rating: 4.9,
        reviewCount: 4000,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Dedicated to the divine love of Krishna and Radha',
      ),
      Temple(
        id: '10',
        name: 'Chandrodaya Mandir',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'Chandrodaya Mandir, also known as Krishna Balram Mandir, is a prominent ISKCON temple dedicated to Lord Krishna and Balarama.',
        history: 'Affiliated with ISKCON, established in the 20th century.',
        builtYear: 'Under Construction (Planned 2016)',
        features: [
          'Modern Architecture',
          'Beautiful Deities',
          'Spiritual Atmosphere',
          'Cultural Events',
        ],
        festivals: ['Janmashtami', 'Radhastami', 'Gaura Purnima'],
        timings: 'Early morning to late evening',
        entryFee: 'Free (Donations welcome)',
        tips: [
          'Attend Cultural Events',
          'Respect Temple Rules',
          'Explore Spiritual Programs',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1992039859/photo/the-mayapur-iskcon-temple.jpg?s=612x612&w=0&k=20&c=Di4XlApwqz1Ieo1uKDu2pQKBInbxwLRBKTFOSWWC77I=',
        rating: 4.7,
        reviewCount: 1800,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Promotes Krishna consciousness through ISKCON',
      ),
      Temple(
        id: '11',
        name: 'Char Dham Temple',
        location: 'Chhatikara, Vrindavan, Uttar Pradesh',
        description:
            'Char Dham Temple is a stunning spiritual complex replicating the four sacred Char Dham sites in India - Badrinath, Dwarka, Puri, and Rameswaram, offering a haven for spiritual growth.',
        history:
            'A modern complex built to unite the essence of the four Char Dham pilgrimage sites.',
        builtYear: 'Modern',
        features: [
          'Four Sacred Shrines',
          'Vaishna Devi Dham',
          'Shiv Dham and Shani Dham',
          'Radha Krishna Dham',
        ],
        festivals: ['Holi', 'Janmashtami', 'Diwali'],
        timings: '7:00 AM to 1:00 PM, 4:00 PM to 8:00 PM',
        entryFee: 'Free',
        tips: [
          'Explore All Shrines',
          'Visit Nearby Prem Mandir',
          'Use Ample Parking',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1283355990/photo/siddheswar-dham-or-char-dham-temple.jpg?s=612x612&w=0&k=20&c=7ckqt0OjZP0cJo3KXrHM46HXTosQwrceQreMbY88Sos=',
        rating: 4.7,
        reviewCount: 2800,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance:
            'Replicates the spiritual essence of the four Char Dham sites',
      ),
      Temple(
        id: '12',
        name: 'Gopeshwar Mahadev Temple',
        location: 'Vrindavan, Uttar Pradesh',
        description:
            'A revered Shiva temple where Lord Shiva is worshipped as a Gopi, known for its unique mythology and worship practices.',
        history:
            'One of the oldest temples in Vrindavan, tied to Shiva’s participation in Krishna’s Raasleela.',
        builtYear: 'Ancient',
        features: [
          'Shiva as Gopi',
          'Oldest Temple',
          'Unique Worship Practices',
          'Spiritual Atmosphere',
        ],
        festivals: ['Shivratri', 'Janmashtami', 'Holi'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Attend Evening Gopi Worship',
          'Respect Sacred Practices',
          'Visit via Mathura Junction',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/476682962/photo/ancient-temple-in-the-gopeshwar.jpg?s=612x612&w=0&k=20&c=FqlB8s3U6IqZiP8NPn0jQrrzEvXXSke3jR1fxy5SaG0=',
        rating: 4.6,
        reviewCount: 2000,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Unique blend of Shiva and Krishna devotion',
      ),
      Temple(
        id: '13',
        name: 'Kokilavan Shani Temple',
        location: 'Kosi Kalan, Mathura, Uttar Pradesh',
        description:
            'An ancient temple dedicated to Shani Dev, nestled in a dense forest, known as Cuckoo’s Forest, linked to Lord Krishna’s blessings.',
        history:
            'Tied to the mythological story of Krishna blessing Shani Dev in the forest.',
        builtYear: 'Ancient',
        features: [
          'Shani Dev Statue',
          'Multiple Temples in Complex',
          'Two Large Ponds',
          'Cow Shelter',
        ],
        festivals: ['Shani Jayanti', 'Holi', 'Janmashtami'],
        timings:
            'Fri-Sat: 24 hours, Other days: 6:00 AM to 8:00 PM, Sun: 12:00 AM to 9:00 PM',
        entryFee: 'Free',
        tips: [
          'Visit on Saturday for Shani Puja',
          'Explore Entire Complex',
          'Respect Forest Sanctity',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1130670406/photo/a-beautiful-hindu-temple-in-black-stone-at-mandvi-budruk-pune-district.jpg?s=612x612&w=0&k=20&c=GMeTBLUwXj0xnbv-GQH8TARoLHZ7daly__AENLweXv4=',
        rating: 4.5,
        reviewCount: 1700,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Pilgrimage site for those affected by Shani’s influence',
      ),
      Temple(
        id: '14',
        name: 'Shri Radha Rani Temple',
        location: 'Barsana, Mathura, Uttar Pradesh',
        description:
            'Also known as Ladli Ji Mandir, this prominent temple on Bhanugarh Hill is dedicated to Radha Rani, the beloved consort of Lord Krishna.',
        history:
            'Associated with Radha’s childhood in Barsana, a key site in Braj.',
        builtYear: 'Ancient',
        features: [
          'Bhanugarh Hill Location',
          'Intricate Architecture',
          'Spiritual Atmosphere',
          '225 Steep Steps',
        ],
        festivals: ['Lathmar Holi', 'Janmashtami', 'Radha Ashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Prepare for Steep Climb',
          'Visit During Lathmar Holi',
          'Explore Prem Sarovar Nearby',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2201833041/photo/pilgrims-at-radharani-temple-in-barsana-india.jpg?s=612x612&w=0&k=20&c=VKhixc3Qv676Jvgk14k7wZ79gCrnA6hzCJii990jHy0=',
        rating: 4.8,
        reviewCount: 3000,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Celebrates Radha’s divine love with Krishna',
      ),
      Temple(
        id: '15',
        name: 'Girraj Ji Temple',
        location: 'Govardhan, Mathura, Uttar Pradesh',
        description:
            'Situated at the base of Govardhan Hill, this temple is dedicated to Girraj Ji (Lord Krishna), revered for Krishna’s miracle of lifting the hill.',
        history:
            'Tied to Krishna’s divine leela of lifting Govardhan Hill to protect Vrindavan.',
        builtYear: 'Ancient',
        features: [
          'Govardhan Hill Proximity',
          'Sacred Parikrama Path',
          'Traditional Architecture',
          'Spiritual Significance',
        ],
        festivals: ['Govardhan Puja', 'Holi', 'Janmashtami'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Perform Parikrama',
          'Visit During Govardhan Puja',
          'Wear Comfortable Shoes',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/181928734/photo/old-temple-at-amber-city-of-jaipur-india.jpg?s=612x612&w=0&k=20&c=xzBRFNh25rzPlLW_4laX_jAmZ1Dqt3QcQMzTXYlyZuk=',
        rating: 4.7,
        reviewCount: 2200,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Site of Krishna’s miracle with Govardhan Hill',
      ),
      Temple(
        id: '16',
        name: 'Yashoda Nandan Temple',
        location: 'Gokul, Mathura, Uttar Pradesh',
        description:
            'A temple in Gokul dedicated to Lord Krishna as a child, associated with his childhood leelas with Nanda and Yashoda.',
        history:
            'Linked to Krishna’s childhood in Gokul, a significant Braj site.',
        builtYear: 'Ancient',
        features: [
          'Child Krishna Deity',
          'Traditional Architecture',
          'Gokul Kund Nearby',
          'Cultural Heritage',
        ],
        festivals: ['Janmashtami', 'Holi', 'Nandotsav'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Visit Raman Reti',
          'Explore Gokul Kund',
          'Participate in Festivals',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/1616505459/photo/festival.jpg?s=612x612&w=0&k=20&c=kjd6tjw2HWw11YYmeYdky_tX8ma3ngmhJc_ozgY-uXc=',
        rating: 4.6,
        reviewCount: 1900,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Celebrates Krishna’s childhood in Gokul',
      ),
      Temple(
        id: '17',
        name: 'Nandagram Temple',
        location: 'Nandgaon, Mathura, Uttar Pradesh',
        description:
            'A temple dedicated to Lord Krishna and his foster parents, Nanda and Yashoda, associated with Krishna’s childhood leelas.',
        history:
            'Linked to Nandgaon as the residence of Nanda, Krishna’s foster father.',
        builtYear: 'Ancient',
        features: [
          'Nanda Bhawan',
          'Traditional Architecture',
          'Spiritual Atmosphere',
          'Cultural Heritage',
        ],
        festivals: ['Holi', 'Janmashtami', 'Nandotsav'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Experience Holi Celebrations',
          'Visit Nand Bhawan',
          'Dress Modestly',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2150142557/photo/an-indian-temple-shot.jpg?s=612x612&w=0&k=20&c=Z8InSRwi0XhUHEh_0ipNPmeSGj8N6ybvxvKR6-Jojm0=',
        rating: 4.6,
        reviewCount: 1800,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance: 'Associated with Krishna’s childhood in Nandgaon',
      ),
      Temple(
        id: '18',
        name: 'Dauji Temple',
        location: 'Baldeo, Mathura, Uttar Pradesh',
        description:
            'A revered temple dedicated to Lord Balaram, Krishna’s elder brother, known for his strength, courage, and loyalty.',
        history:
            'A significant pilgrimage site in Braj with deep mythological roots.',
        builtYear: 'Ancient',
        features: [
          'Sacred Balaram Idols',
          'Traditional Architecture',
          'Spiritual Atmosphere',
          'Cultural Heritage',
        ],
        festivals: ['Balaram Jayanti', 'Janmashtami', 'Holi (Huranga)'],
        timings: 'Early morning to late evening',
        entryFee: 'Free',
        tips: [
          'Attend Balaram Jayanti',
          'Respect Temple Traditions',
          'Explore Baldeo Town',
        ],
        imageUrl:
            'https://media.istockphoto.com/id/2127997569/photo/dauji-huranga-holi.jpg?s=612x612&w=0&k=20&c=6rhtOhjGyk2h-xQ8UOPBY9nMxag_WRdL7G92tMv7UYg=',
        rating: 4.5,
        reviewCount: 1600,
        galleryImages: [
          'https://media.istockphoto.com/id/2217156915/photo/idol-of-divine-god-krishna-and-goddess-radha-at-holy-temple-indoor.jpg?s=612x612&w=0&k=20&c=pC-3-3mUXsDBuyqU6B5EhT2mYPxHPgkPNneH-Mst4WA=',
          'https://media.istockphoto.com/id/541306874/photo/hindu-god-krishna-with-his-wife-radha.jpg?s=612x612&w=0&k=20&c=F111-SOkqEUTkK1sEJ58x9x-WTV0Y-K1ZtufmxVESms=',
          'https://media.istockphoto.com/id/1183358706/photo/entrance-gate-of-nidhivan.jpg?s=612x612&w=0&k=20&c=XrfB_9LL8htZT5gwEqXqlC6zaHILwHvZTpl3a2HJex8=',
        ],
        significance:
            'Dedicated to Lord Balaram, a key figure in Krishna’s leelas',
      ),
    ];
  }

  List<TourGuide> _getTourGuideData() {
    return [
      TourGuide(
        id: '1',
        name: 'Pandit Ramesh Sharma',
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.9,
        reviewCount: 450,
        languages: ['Hindi', 'English', 'Sanskrit'],
        specializations: ['Temple History', 'Mythology', 'Spiritual Guidance'],
        experience: '15+ years',
        pricePerHour: 500.0,
        pricePerDay: 3000.0,
        isAvailable: true,
        description:
            'Expert guide with deep knowledge of Braj temples and Krishna mythology. Fluent in multiple languages with spiritual insights.',
        contactNumber: '+91-9876543210',
        certifications: [
          'Certified Tour Guide',
          'Sanskrit Scholar',
          'Religious Studies',
        ],
      ),
      TourGuide(
        id: '2',
        name: 'Shri Gopal Das',
        imageUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.8,
        reviewCount: 380,
        languages: ['Hindi', 'English', 'Bengali'],
        specializations: [
          'Cultural Heritage',
          'Festival Celebrations',
          'Local Traditions',
        ],
        experience: '12+ years',
        pricePerHour: 450.0,
        pricePerDay: 2700.0,
        isAvailable: true,
        description:
            'Passionate guide specializing in cultural heritage and festival celebrations. Great storyteller with local insights.',
        contactNumber: '+91-9876543211',
        certifications: ['Tourism Board Certified', 'Cultural Heritage Expert'],
      ),
      TourGuide(
        id: '3',
        name: 'Mata Sudha Devi',
        imageUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.7,
        reviewCount: 320,
        languages: ['Hindi', 'English'],
        specializations: [
          'Women\'s Spiritual Journey',
          'Radha Krishna Stories',
          'Devotional Practices',
        ],
        experience: '10+ years',
        pricePerHour: 400.0,
        pricePerDay: 2500.0,
        isAvailable: false,
        description:
            'Female guide specializing in women\'s spiritual journeys and devotional practices. Expert in Radha Krishna stories.',
        contactNumber: '+91-9876543212',
        certifications: [
          'Religious Guide License',
          'Women\'s Spiritual Counselor',
        ],
      ),
      TourGuide(
        id: '4',
        name: 'Vikram Singh',
        imageUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.6,
        reviewCount: 290,
        languages: ['Hindi', 'English', 'Punjabi'],
        specializations: [
          'Historical Sites',
          'Braj Culture',
          'Pilgrimage Routes',
        ],
        experience: '8+ years',
        pricePerHour: 400.0,
        pricePerDay: 2400.0,
        isAvailable: true,
        description:
            'Knowledgeable guide with expertise in Braj’s historical sites and pilgrimage routes, offering engaging tours.',
        contactNumber: '+91-9876543213',
        certifications: ['Certified Pilgrimage Guide', 'History Enthusiast'],
      ),
      TourGuide(
        id: '5',
        name: 'Anita Mishra',
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.8,
        reviewCount: 360,
        languages: ['Hindi', 'English', 'Marathi'],
        specializations: [
          'Temple Rituals',
          'Spiritual Storytelling',
          'Local Cuisine',
        ],
        experience: '11+ years',
        pricePerHour: 450.0,
        pricePerDay: 2700.0,
        isAvailable: true,
        description:
            'Experienced guide offering insights into temple rituals and spiritual stories, with a touch of local culinary knowledge.',
        contactNumber: '+91-9876543214',
        certifications: ['Certified Spiritual Guide', 'Cultural Ambassador'],
      ),
      TourGuide(
        id: '6',
        name: 'Suresh Yadav',
        imageUrl:
            'https://images.unsplash.com/photo-1506794778202-6d8d16e4b9a6?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.5,
        reviewCount: 250,
        languages: ['Hindi', 'English'],
        specializations: [
          'Mythological Tours',
          'Vrindavan Heritage',
          'Aarti Ceremonies',
        ],
        experience: '7+ years',
        pricePerHour: 380.0,
        pricePerDay: 2200.0,
        isAvailable: false,
        description:
            'Dedicated guide with a focus on mythological tours and Vrindavan’s heritage, known for lively aarti explanations.',
        contactNumber: '+91-9876543215',
        certifications: ['Tourism Guide License', 'Mythology Expert'],
      ),
      TourGuide(
        id: '7',
        name: 'Priya Sharma',
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.9,
        reviewCount: 400,
        languages: ['Hindi', 'English', 'Gujarati'],
        specializations: [
          'Radha Krishna Leelas',
          'Festival Tours',
          'Spiritual Guidance',
        ],
        experience: '13+ years',
        pricePerHour: 480.0,
        pricePerDay: 2900.0,
        isAvailable: true,
        description:
            'Passionate guide specializing in Radha Krishna leelas and festival tours, offering deep spiritual insights.',
        contactNumber: '+91-9876543216',
        certifications: ['Certified Spiritual Guide', 'Festival Expert'],
      ),
      TourGuide(
        id: '8',
        name: 'Rakesh Kumar',
        imageUrl:
            'https://images.unsplash.com/photo-1522556189639-b1509e4e3f66?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.7,
        reviewCount: 310,
        languages: ['Hindi', 'English', 'Tamil'],
        specializations: [
          'Temple Architecture',
          'Historical Narratives',
          'Braj Pilgrimage',
        ],
        experience: '9+ years',
        pricePerHour: 420.0,
        pricePerDay: 2500.0,
        isAvailable: true,
        description:
            'Expert in temple architecture and historical narratives, providing detailed tours of Braj pilgrimage sites.',
        contactNumber: '+91-9876543217',
        certifications: ['Certified Tour Guide', 'Architecture Historian'],
      ),
      TourGuide(
        id: '9',
        name: 'Meena Gupta',
        imageUrl:
            'https://images.unsplash.com/photo-1517365830460-955ce3f6b1f6?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.6,
        reviewCount: 280,
        languages: ['Hindi', 'English'],
        specializations: [
          'Women’s Pilgrimage',
          'Devotional Practices',
          'Local Culture',
        ],
        experience: '8+ years',
        pricePerHour: 400.0,
        pricePerDay: 2400.0,
        isAvailable: false,
        description:
            'Specializes in women’s pilgrimage experiences, offering insights into devotional practices and local culture.',
        contactNumber: '+91-9876543218',
        certifications: ['Women’s Spiritual Guide', 'Cultural Expert'],
      ),
      TourGuide(
        id: '10',
        name: 'Krishna Chaitanya',
        imageUrl:
            'https://images.unsplash.com/photo-1502685104226-ee32379f453f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.8,
        reviewCount: 370,
        languages: ['Hindi', 'English', 'Telugu'],
        specializations: [
          'Krishna Bhakti',
          'Spiritual Retreats',
          'Temple Stories',
        ],
        experience: '12+ years',
        pricePerHour: 460.0,
        pricePerDay: 2800.0,
        isAvailable: true,
        description:
            'Devoted guide with deep knowledge of Krishna bhakti and temple stories, ideal for spiritual retreats.',
        contactNumber: '+91-9876543219',
        certifications: ['Certified Bhakti Guide', 'Spiritual Retreat Leader'],
      ),
      TourGuide(
        id: '11',
        name: 'Sunita Patel',
        imageUrl:
            'https://images.unsplash.com/photo-1512969872561-8b6c7f80e3e0?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.7,
        reviewCount: 330,
        languages: ['Hindi', 'English', 'Rajasthani'],
        specializations: [
          'Festival Experiences',
          'Braj Heritage',
          'Spiritual Journeys',
        ],
        experience: '10+ years',
        pricePerHour: 430.0,
        pricePerDay: 2600.0,
        isAvailable: true,
        description:
            'Engaging guide offering immersive festival experiences and insights into Braj’s spiritual heritage.',
        contactNumber: '+91-9876543220',
        certifications: ['Certified Festival Guide', 'Heritage Specialist'],
      ),
      TourGuide(
        id: '12',
        name: 'Arjun Verma',
        imageUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.5,
        reviewCount: 260,
        languages: ['Hindi', 'English'],
        specializations: [
          'Historical Tours',
          'Local Legends',
          'Pilgrimage Sites',
        ],
        experience: '7+ years',
        pricePerHour: 390.0,
        pricePerDay: 2300.0,
        isAvailable: false,
        description:
            'Knowledgeable guide with a focus on historical tours and local legends, perfect for exploring pilgrimage sites.',
        contactNumber: '+91-9876543221',
        certifications: ['Tourism Board Certified', 'History Guide'],
      ),
      TourGuide(
        id: '13',
        name: 'Radha Kumari',
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        rating: 4.9,
        reviewCount: 390,
        languages: ['Hindi', 'English', 'Bhojpuri'],
        specializations: [
          'Radha Krishna Mythology',
          'Spiritual Guidance',
          'Cultural Tours',
        ],
        experience: '14+ years',
        pricePerHour: 470.0,
        pricePerDay: 2850.0,
        isAvailable: true,
        description:
            'Expert guide specializing in Radha Krishna mythology and spiritual guidance, offering rich cultural tours.',
        contactNumber: '+91-9876543222',
        certifications: ['Certified Spiritual Guide', 'Cultural Storyteller'],
      ),
    ];
  }

  void toggleFavorite(String templeId) {
    final favorites = List<String>.from(state.favoriteTemples);
    if (favorites.contains(templeId)) {
      favorites.remove(templeId);
    } else {
      favorites.add(templeId);
    }
    state = state.copyWith(favoriteTemples: favorites);
  }

  void selectGuide(String guideId) {
    state = state.copyWith(selectedGuideId: guideId);
  }
}

class BrajDarshanState {
  final List<Temple> temples;
  final List<TourGuide> tourGuides;
  final List<String> favoriteTemples;
  final String? selectedGuideId;
  final bool isLoading;

  const BrajDarshanState({
    this.temples = const [],
    this.tourGuides = const [],
    this.favoriteTemples = const [],
    this.selectedGuideId,
    this.isLoading = true,
  });

  BrajDarshanState copyWith({
    List<Temple>? temples,
    List<TourGuide>? tourGuides,
    List<String>? favoriteTemples,
    String? selectedGuideId,
    bool? isLoading,
  }) {
    return BrajDarshanState(
      temples: temples ?? this.temples,
      tourGuides: tourGuides ?? this.tourGuides,
      favoriteTemples: favoriteTemples ?? this.favoriteTemples,
      selectedGuideId: selectedGuideId ?? this.selectedGuideId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final brajDarshanProvider =
    StateNotifierProvider<BrajDarshanNotifier, BrajDarshanState>(
      (ref) => BrajDarshanNotifier(),
    );
