const functions = require("firebase-functions");
const axios = require("axios");

const GEMINI_API_KEY = functions.config().openai.key;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GEMINI_API_KEY}`;

exports.generateQuizWithAI = functions.https.onCall(async (data, context) => {
  const { topic, difficulty, level } = data;

  if (!topic || !difficulty || !level) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing parameters');
  }

  const prompt = `Generate a ${difficulty} level quiz on the topic "${topic}" for a user with "${level}" knowledge. Format the result as a list of questions with 4 options each, and the correct answer marked.`;

  try {
    const response = await axios.post(
      GEMINI_URL,
      {
        // Adjust this according to Gemini API spec:
        prompt: {
          text: prompt,
        },
        // You might need to add additional parameters here
      },
      {
        headers: { "Content-Type": "application/json" },
      }
    );

    console.log('Gemini API response:', JSON.stringify(response.data, null, 2));

    const quizText = response?.data?.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!quizText) {
      throw new functions.https.HttpsError('internal', 'No quiz content returned from Gemini');
    }

    return { quiz: quizText };
  } catch (error) {
    console.error("Error calling Gemini API:", error.response?.data || error.message || error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to generate quiz with AI"
    );
  }
});
