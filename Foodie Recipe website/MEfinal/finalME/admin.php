<h2>To Be Deleted:</h2>
<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "test";

$connection = mysqli_connect($servername, $username, $password, $database);

if (!$connection) {
    die("Connection failed: " . mysqli_connect_error());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $recipeName = mysqli_real_escape_string($connection, $_POST['recipeName']);
    $directions = mysqli_real_escape_string($connection, $_POST['directions']);
    $nutritionFacts = mysqli_real_escape_string($connection, $_POST['nutritionFacts']);

    $imageUrl = isset($_POST['imageUrl']) ? mysqli_real_escape_string($connection, $_POST['imageUrl']) : '';

    $insertRecipeQuery = "INSERT INTO recipes (name, directions, nutrition_facts, image_url) VALUES ('$recipeName', '$directions', '$nutritionFacts', '$imageUrl')";
    mysqli_query($connection, $insertRecipeQuery);
    
    $recipeId = mysqli_insert_id($connection); 
    if (isset($_POST['ingredients']) && is_array($_POST['ingredients'])) {
        foreach ($_POST['ingredients'] as $ingredient) {
            $ingredientName = mysqli_real_escape_string($connection, $ingredient);
            $insertIngredientQuery = "INSERT INTO ingredients (recipe_id, ingredient_name) VALUES ($recipeId, '$ingredientName')";
            mysqli_query($connection, $insertIngredientQuery);
        }
    }
}
$selectRecipesQuery = "SELECT * FROM recipes";
$recipesResult = mysqli_query($connection, $selectRecipesQuery);
while ($row = mysqli_fetch_assoc($recipesResult)) {
    $recipeId = $row['id'];
    $recipeName = $row['name'];
    $directions = $row['directions'];
    $nutritionFacts = $row['nutrition_facts'];
    $imageUrl = $row['image_url'];

    echo "<div class='recipe-container'>";
    echo "<center><h2>$recipeName</h2></center>";
    echo "<center><img src='$imageUrl' ></center>";
    echo "<form method='post' action='update.php'>";
    echo "<input type='hidden' name='updatedImageUrl' value='$recipeId'>";
    echo "<label for='updatedImageUrl'>Update Image:</label>";
    echo "<input type='text' name='updatedImageUrl' required>";
    echo "<button type='submit' class='update-recipe'>Update image</button>";
    echo "</form>";
    echo "<form method='post' action='update.php'>";
    echo "<input type='hidden' name='updateRecipeId' value='$recipeId'>";
    echo "<label for='updatedRecipeName'>Update Recipe Name:</label>";
    echo "<input type='text' name='updatedRecipeName' required>";
    echo "<button type='submit' class='update-recipe'>Update Recipe</button>";
    echo "</form>";
    echo "<p>Directions: $directions</p>";
    echo "<form method='post' action='update.php'>";
    echo "<input type='hidden' name='updateRecipeId' value='$recipeId'>";
    echo "<label for='updatedDirections'>Update Directions:</label>";
    echo "<textarea name='updatedDirections' required></textarea>";
    echo "<button type='submit' class='update-recipe'>Update Direction</button>";
    echo "</form>";
    echo "<p>Nutrition Facts: $nutritionFacts</p>";
    echo "<form method='post' action='update.php'>";
    echo "<input type='hidden' name='updateRecipeId' value='$recipeId'>";
    echo "<label for='updatedNutritionFacts'>Update Nutrition:</label>";
    echo "<textarea name='updatedNutritionFacts' required></textarea>";
    echo "<button type='submit' class='update-recipe'>Update Nutrition</button>";
    echo "</form>";
    
   
echo "<p>Ingredients:</p>";
echo "<center>";
    $selectIngredientsQuery = "SELECT * FROM ingredients WHERE recipe_id = $recipeId";
    $ingredientsResult = mysqli_query($connection, $selectIngredientsQuery);

   
    echo "<ul>";
    while ($ingredientRow = mysqli_fetch_assoc($ingredientsResult)) {
        $ingredientId = $ingredientRow['id'];
        $ingredientName = $ingredientRow['ingredient_name'];
        echo "<li>$ingredientName ";
        echo "<form method='post' style='display:inline; margin:0;' action='delete.php'>";
        echo "<input type='hidden' name='deleteIngredientId' value='$ingredientId'>";
        echo "<button type='submit' class='delete-ingredient'>Delete</button>";
        echo "</form>";
        echo "<form method='post' action='update.php'>";
    echo "<input type='hidden' name='updateIngredientId' value='$ingredientId'>";
    echo "<label for='updatedIngredientName'></label>";
    echo "<input type='text' name='updatedIngredientName' required>";
    echo "<button type='submit' class='update-ingredient'>Update Ingredient</button>";
    echo "</form>";
        echo "</li>";
    }
    echo "</ul>";

    echo "<form method='post' action='delete.php'>";
    echo "<input type='hidden' name='deleteRecipeId' value='$recipeId'>";
    echo "<center><button type='submit' class='delete-recipe'>Delete Recipe</button></center>";
    echo "</form>";

    echo "</div>";
}
echo "</center>";

?>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe Admin</title>
    <link rel="stylesheet" href="path/to/your/healthy.css">
</head>
<body>
    <center>
<h2>Add New Recipe:</h2>
</center>
<div class="add-recipe-form">

    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
        <table>
            <tr>
                <td><label for="recipeName">Recipe Name:</label></td>
                <td><input type="text" name="recipeName" required></td>
            </tr>
            <tr>
                <td><label for="directions">Directions:</label></td>
                <td><textarea name="directions" rows="4" required></textarea></td>
            </tr>
            <tr>
                <td><label for="nutritionFacts">Nutrition Facts:</label></td>
                <td><textarea name="nutritionFacts" rows="4" required></textarea></td>
            </tr>
            <tr>
                <td><label for="imageUrl">Image URL:</label></td>
                <td><input type="text" name="imageUrl" required></td>
            </tr>
            <tr>
                <td><label for="ingredients">Ingredients:</label></td>
                <td>
                    <div id="ingredients-container">
                        <input type="text" name="ingredients[]" required>
                    </div>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><button type="button" onclick="addIngredientField()">Add Ingredients</button></td>
            </tr>
            <tr>
                <td></td>
                <td><button type="submit">Add Recipe</button></td>
            </tr>
        </table>
    </form>
</div>
<style>
body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }
        .add-recipe-form{
            width:100%;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .recipe-container {
        
            background-color: #fff;
            margin: 20px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
        }

        img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        form {
            margin-top: 10px;
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"],
        input[type="password"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }

        button {
            background-color: #4caf50;
            color: #fff;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        li {
            margin-bottom: 10px;
        }

        .delete-ingredient,
        .update-ingredient,
        .delete-recipe {
            background-color: #d9534f;
        }

        .delete-ingredient:hover,
        .update-ingredient:hover,
        .delete-recipe:hover {
            background-color: #c9302c;
        }
    </style>
<script>
function addIngredientField() {
    const ingredientsContainer = document.getElementById('ingredients-container');
    const newIngredientField = document.createElement('input');
    newIngredientField.type = 'text';
    newIngredientField.name = 'ingredients[]';
    newIngredientField.required = true;
    ingredientsContainer.appendChild(newIngredientField);
}
</script>

<?php

mysqli_close($connection);
?>

</body>
</html>