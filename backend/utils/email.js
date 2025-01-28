const nodemailer = require('nodemailer');


async function sendEmail(to, subject, body) {
  try
  {
    const from = 'mailer.learnx@gmail.com';
    const password = 'glfd kcgf dhpx hiwk';

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: from,
            pass: password
        }
    });

    const mailOptions = {
        from: from,
        to: to,
        subject: subject,
        text: body
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Email sent successfully to ${to}`);
    } catch (err) {
        console.error(`Error sending email to ${to}: ${err}`);
    }
  }catch(err){
    console.error(err);
    console.log(err);
    
    
  }

}

module.exports = { sendEmail };