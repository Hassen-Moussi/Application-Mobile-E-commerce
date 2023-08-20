



import '../../utilities/c_images.dart';

class UnbordingContent {
  String image;
  String title;
  String discription;
  UnbordingContent({required this.image, required this.title, required this.discription});
}
List<UnbordingContent> contents = [

  UnbordingContent(
      title: "Let's get started",
      image: CImages.start,
      discription: "Welcome to dyno, We're excited to have you on board. To help you get started, here's a step-by-step guide on how to use our app"
  ),
  UnbordingContent(
      title: 'Login  ',
      image: CImages.Login,
      discription: " Enter your login credentials to access your account and dive back into our amazing app.  We're here to provide you with a seamless experience, so let's get started! "
  ),
  UnbordingContent(
      title: 'Forgot your password?',
      image: CImages.reset,
      discription: "No worries, we've got you covered! Follow these simple steps to reset your password and regain access to your account"

  ),
  UnbordingContent(
      title: 'Payment with qr code',
      image: CImages.qrcode,
      discription: "Use your payment app's scan feature to scan QR codes for payment or generate your own QR code to receive payments."
  ),
  UnbordingContent(
      title: 'Safety transaction',
      image: CImages.transaction,
      discription: " Prioritize safety in transactions by using trusted methods, verifying details, and staying vigilant against potential risks. "
  ),
];