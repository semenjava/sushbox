<!DOCTYPE html>
<html>
<head>
    <title>Payment</title>
</head>
<body>
    <h1>Payment</h1>
    <form action="{{ route('payment.create') }}" method="POST">
        @csrf
        <label for="amount">Amount:</label>
        <input type="text" id="amount" name="amount" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <br>
        <button type="submit">Pay</button>
    </form>
</body>
</html>
