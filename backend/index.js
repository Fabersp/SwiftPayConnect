const express = require("express");
const Stripe = require("stripe");
const cors = require("cors");

const app = express();
const stripe = Stripe("sk_test_51RYuAWBCUP1U3KirjpLU9cOqaFiV74M5lCUXbDqTqxOOyQ6xpgvC3LuE9LkBgPWZgASDYe7bOZLuoqm6IaoG8S6v00DocAk9cQ");

app.use(cors());
app.use(express.json());

app.post("/create-payment-intent", async (req, res) => {
  try {
    const { amount } = req.body;
    
    if (!amount || amount <= 0) {
      return res.status(400).send({ error: "Invalid amount" });
    }

    // Create a customer
    const customer = await stripe.customers.create();
    
    // Create an ephemeral key for the customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: "2023-10-16" }
    );

    // Create a payment intent with the amount and additional options
    const paymentIntent = await stripe.paymentIntents.create({
      amount: 1000,
      currency: 'usd',
      customer: customer.id,
      // mantém apenas esta linha:
      payment_method_types: ['card']
      // REMOVA automatic_payment_methods
    });

    res.send({
      paymentIntent: paymentIntent.client_secret,
      customer: customer.id,
      ephemeralKey: ephemeralKey.secret,
      publishableKey: "pk_test_51RYuAWBCUP1U3KirxfUgOjqZ1YtTjc9GljkYSulIOQ4MIvibDjJ9lyHC2MU4ir0r4nIDu18qEpDVrqyTqcKz5A9L001ZhCnwbJ"
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(400).send({ 
      error: error.message,
      type: error.type,
      code: error.code
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`)); 