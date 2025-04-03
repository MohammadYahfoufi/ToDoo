<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "test";

$connection = mysqli_connect($servername, $username, $password, $database);

if (!$connection) {
    die("Connection failed: " . mysqli_connect_error());
}

// Check if update button for a recipe is clicked
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['updateRecipeId']) && isset($_POST['updatedRecipeName'])) {
    $updateRecipeId = mysqli_real_escape_string($connection, $_POST['updateRecipeId']);
    $updatedRecipeName = mysqli_real_escape_string($connection, $_POST['updatedRecipeName']);

    // Check if an updated image URL is provided
    $updatedImageUrl = isset($_POST['updatedImageUrl']) ? mysqli_real_escape_string($connection, $_POST['updatedImageUrl']) : '';

   
}

// Check if update button for an ingredient is clicked
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['updateIngredientId']) && isset($_POST['updatedIngredientName'])) {
    $updateIngredientId = mysqli_real_escape_string($connection, $_POST['updateIngredientId']);
    $updatedIngredientName = mysqli_real_escape_string($connection, $_POST['updatedIngredientName']);
    $updateIngredientQuery = "UPDATE ingredients SET ingredient_name = '$updatedIngredientName' WHERE id = $updateIngredientId";
    mysqli_query($connection, $updateIngredientQuery);
}


if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['updateRecipeId']) && isset($_POST['updatedDirections'])) {
    $updateIngredientId = mysqli_real_escape_string($connection, $_POST['updateRecipeId']);
    $updatedDirections = mysqli_real_escape_string($connection, $_POST['updatedDirections']);

    // Assuming 'directions' is the column in the ingredients table
    $updateIngredientQuery = "UPDATE recipes SET directions = '$updatedDirections' WHERE id = $updateIngredientId";

    mysqli_query($connection, $updateIngredientQuery);
}
    
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['updateRecipeId']) && isset($_POST['updatedNutritionFacts'])) {
    $updateRecipeId = mysqli_real_escape_string($connection, $_POST['updateRecipeId']);
    $updatedNutritionFacts = mysqli_real_escape_string($connection, $_POST['updatedNutritionFacts']);
    
    // Assuming 'nutrition_facts' is the column in the recipes table
    $updateRecipeQuery = "UPDATE recipes SET nutrition_facts = '$updatedNutritionFacts' WHERE id = $updateRecipeId";
    
    mysqli_query($connection, $updateRecipeQuery);
}
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['updateRecipeId']) && isset($_POST['updatedImageUrl'])) {
    $updateRecipeId = mysqli_real_escape_string($connection, $_POST['updateRecipeId']);
    $updatedImageUrl = mysqli_real_escape_string($connection, $_POST['updatedImageUrl']);
    
    // Assuming 'image_url' is the column in the recipes table
    $updateRecipeQuery = "UPDATE recipes SET image_url = '$updatedImageUrl' WHERE id = $updateRecipeId";
    
    mysqli_query($connection, $updateRecipeQuery);
}



// Redirect back to the main page
header("Location: admin.php");
exit();

mysqli_close($connection);
?>

