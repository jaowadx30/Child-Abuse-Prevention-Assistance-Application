import 'package:child_abuse_prevention/src/model/legal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';

class AbuseLearn extends StatefulWidget {
  const AbuseLearn({super.key, required this.index});
  final int index;
  @override
  State<AbuseLearn> createState() => _AbuseLearnState();
}

class _AbuseLearnState extends State<AbuseLearn> {
  List<LegalData> data = [
    new LegalData(
        title: "Emotional Abuse",
        desc:
            """Overcoming emotional abuse in children requires a combination of supportive environments, intervention, and professional help. Here are some steps that can be taken to address and mitigate the effects of emotional abuse:

<p>Recognize the signs:</br>Awareness of emotional abuse is crucial. Educate yourself about the signs and effects of emotional abuse on children. This will help you identify if a child is experiencing emotional abuse and take appropriate action.</br>
<b>Create a safe and supportive environment:</b>Establish a safe and nurturing environment where the child feels valued, loved, and supported. Encourage open communication, active listening, and empathy. Provide consistent care, set clear boundaries, and promote positive reinforcement.</br>
<b>Validate their feelings:</b>Emotional abuse often undermines a child's self-esteem and makes them doubt their emotions and perceptions. Validate their feelings, let them know that their experiences matter, and provide reassurance that they are not to blame for the abuse.</br>
<b>Encourage expression:</b> Encourage the child to express their emotions in healthy ways, such as through art, writing, or talking to a trusted adult. Create opportunities for them to share their experiences and feelings without judgment or criticism.</br>
<b>Seek professional help:</b> It is important to involve professionals who can provide specialized support. A child psychologist, therapist, or counselor with experience in trauma and abuse can help the child process their emotions, develop coping strategies, and rebuild their self-esteem.</p>""",
        image: "assets/images/Emotional.jpg"),
    new LegalData(
        title: "Neglect",
        desc: """
<p>Child neglect is a serious form of child abuse that involves the failure of caregivers to meet a child's basic needs for adequate food, shelter, clothing, education, supervision, and medical care. If you suspect or encounter a situation of child neglect abuse, here are some steps you can take:</br>

<b>Ensure immediate safety:</b> If the child is in immediate danger or at risk of severe harm, contact emergency services or local law enforcement right away to ensure their safety.
<b>Document and gather information:</b> Collect any relevant information or evidence of neglect, such as photographs, notes, or records that illustrate the child's living conditions, lack of essential care, or consistent patterns of neglect. This documentation may be valuable when reporting the situation.</br>
<b>Report to authorities:</b> Contact your local child protection agency, child welfare services, or the appropriate authorities in your area to report the suspected child neglect. Provide them with as much information as possible, including your observations, concerns, and any evidence you have collected.</br>
<b>Encourage the child to speak up:</b> If you have a relationship with the child, let them know that you are there to listen and support them. Encourage them to share their experiences and feelings, but do not pressure or force them to disclose information if they are not comfortable doing so.</br>
<b>Involve professionals:</b> Consult with professionals who can provide guidance and intervention. This can include child protection agencies, social workers, counselors, therapists, or teachers who are mandated reporters. They can assess the situation, initiate investigations, and provide appropriate services to the child and family.</br>
<b>Offer support:</b> If you are close to the child or their family, offer support and resources if they are willing to accept it. This could involve connecting them with community organizations, counseling services.</p>

""",
        image: "assets/images/Neglect.jpg"),
    LegalData(
        title: "Physical Abuse",
        desc: """
<p>If a child is facing physical abuse, it is essential to take immediate action to ensure their safety and well-being. Here are the steps you can take:</br></br>

<b>Ensure the child's safety:</b> If the child is in immediate danger or requires urgent medical attention, call emergency services or local law enforcement right away to ensure their safety.
<b>Document and gather information:</b> If it is safe to do so, document any visible injuries or signs of physical abuse. Take photographs or make detailed notes about the injuries, dates, and any other relevant information that can help establish a record of the abuse.</br>
<b>Report to authorities:</b> Contact your local child protection agency, child welfare services, or the appropriate authorities in your area to report the suspected physical abuse. Provide them with as much information as possible, including your observations, concerns, and any evidence you have collected.</br>
<b>Encourage the child to talk:</b> If you have a relationship with the child, let them know that you are there to listen and support them. Encourage them to share their experiences, but do not pressure or force them to disclose information if they are not comfortable doing so.</br>
<b>Involve professionals:</b> Reach out to professionals who can provide immediate help and intervention, such as child protection agencies, social workers, or law enforcement officers trained in child abuse cases. They can assess the situation, ensure the child's safety, and initiate investigations.</br>
<b>Seek medical attention:</b> If the child has physical injuries, it is crucial to seek medical attention promptly. Take the child to a healthcare professional who can assess and document their injuries and provide any necessary medical treatment.</br></p>

""",
        image: "assets/images/Physical.jpg"),
    LegalData(
        title: "Sexual Abuse",
        desc: """
    <p>If a child is facing sexual abuse, it is crucial to take immediate action to protect the child and ensure their safety and well-being. Here are the steps you can take:</br>

<b>Ensure the child's safety:</b> If the child is in immediate danger or requires urgent medical attention, call emergency services or local law enforcement right away to ensure their safety.</br>
<b>Believe and support the child:</b> If a child discloses sexual abuse to you, believe them and assure them that they are not at fault. It is essential to provide a supportive and non-judgmental environment where the child feels safe to share their experiences.</br>
<b>Report to authorities:</b> Contact your local child protection agency, law enforcement, or the appropriate authorities in your area to report the suspected sexual abuse. Provide them with as much information as possible, including the child's disclosures, your observations, and any evidence you have, if applicable.</br>
<b>Seek medical attention:</b> Arrange for the child to receive immediate medical attention from professionals experienced in dealing with cases of child sexual abuse. It is crucial to prioritize their physical well-being and address any potential injuries or health concerns.</br>
<b>Involve professionals:</b> Contact professionals trained in handling cases of child sexual abuse, such as child protection agencies, social workers, or specialized child advocacy centers. They can conduct investigations, provide support, and ensure appropriate intervention and legal actions are taken.</br>
<b>Preserve evidence:</b> If possible, avoid altering the child's environment or removing any potential evidence of abuse. It is crucial to preserve any physical evidence, such as clothing or objects, that may aid in the investigation and prosecution of the abuser.</br>
<b>Offer emotional support:</b> Connect the child and their family with professionals who can provide specialized support and counseling services for child sexual abuse.</br></p>
""",
        image: "assets/images/Sexual.jpg")
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(data[widget.index].image),
                      opacity: 0.1,
                      fit: BoxFit.cover),
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data[widget.index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_arrow_left)),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: ListView(
              shrinkWrap: true,
              children: [
                Html(
                  data: data[widget.index].desc,
                  style: {
                    'b': Style(fontWeight: FontWeight.w700),
                    'p': Style(
                        fontSize: FontSize.medium,
                        textAlign: TextAlign.justify),
                  },
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
