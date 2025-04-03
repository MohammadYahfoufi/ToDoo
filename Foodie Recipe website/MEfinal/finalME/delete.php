<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "test";

$connection = mysqli_connect($servername, $username, $password, $database);

if (!$connection) {
    die("Connection failed: " . mysqli_connect_error());
}

// Check if delete button for an ingredient is clicked
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['deleteIngredientId'])) {
    $deleteIngredientId = mysqli_real_escape_string($connection, $_POST['deleteIngredientId']);
    $deleteIngredientQuery = "DELETE FROM ingredients WHERE id = $deleteIngredientId";
    mysqli_query($connection, $deleteIngredientQuery);
}

// Check if delete button for a recipe is clicked
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['deleteRecipeId'])) {
    $deleteRecipeId = mysqli_real_escape_string($connection, $_POST['deleteRecipeId']);

    // Delete ingredients associated with the recipe
    $deleteIngredientsQuery = "DELETE FROM ingredients WHERE recipe_id = $deleteRecipeId";
    mysqli_query($connection, $deleteIngredientsQuery);

    // Delete the recipe
    $deleteRecipeQuery = "DELETE FROM recipes WHERE id = $deleteRecipeId";
    mysqli_query($connection, $deleteRecipeQuery);
}

// Redirect back to the main page
header("Location: admin.php");
exit();

mysqli_close($connection);
?>
