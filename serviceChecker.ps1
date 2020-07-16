param (
   [string]$repo = ""
)

$watch = [system.diagnostics.stopwatch]::StartNew()
$root ="component"



$internalPath = "C:\WK_Sourcecode\Repos\" + $repo + "Repo\Newpol\Shell\Modules\" + $repo +"\Client\Scripts\v4\src\internal\components"

$outputPath = "C:\WK_Sourcecode\Repos\" + $repo + "Repo\Newpol\Shell\Modules\"+ $repo + "\Client\Scripts\v4\src\internal\services"


$servicesTested= 0
$servicesNoTestedList= @()
$servicesNoTested= 0
$collectionWithItems = New-Object System.Collections.ArrayList

#internal

Get-ChildItem $internalPath -Recurse -Filter *service.ts | 
Foreach-Object {
    
           $pathSpec =$_.FullName
           $pathSpec = $pathSpec.Replace(".ts",".spec.ts")
          if([System.IO.File]::Exists($pathSpec))
          {

             $inpLineNumbers = (Select-String -Path $pathSpec -Pattern "it").LineNumber

             if($inpLineNumbers -gt 0)
             {
                Write-Host $_.Name "--- (done)" -ForegroundColor Yellow
                Write-Host $pathSpec "--- (Tested)" -ForegroundColor green
                $servicesTested =$servicesTested +1 
             }
             else
             {
                Write-Host 'No tested'
                $servicesNoTestedList +=($_.Name)
                Write-Host $pathSpec -ForegroundColor red
                Write-Host $_.Name "--- (done)" -ForegroundColor Yellow
                $servicesNoTested =$servicesNoTested +1
             }
         }  

   }

#shared

Get-ChildItem $outputPath -Recurse -Filter *service.ts | 
Foreach-Object {
    
           $pathSpec =$_.FullName
           $pathSpec.Replace(".ts",".spec.ts")
          if([System.IO.File]::Exists($pathSpec))
          {

            Write-Host $_.Name "--- (done)" -ForegroundColor Yellow
            Write-Host $pathSpec "--- (Tested)" -ForegroundColor green
            $servicesTested =$servicesTested +1 
          }
          else
          {
            Write-Host 'No tested'
            Write-Host $pathSpec -ForegroundColor red
            Write-Host $_.Name "--- (done)" -ForegroundColor Yellow
            $servicesNoTested =$servicesNoTested +1
          }  

   }


$watch.Stop()

Write-Host "-----"  -ForegroundColor Green
Write-Host "End"  -ForegroundColor Green
$info =@{}
$info.services =  $servicesTested
$info.servicesNoTested =  $servicesNoTested
$info |Format-Table -Property "name", "value" -AutoSize
$servicesNoTestedList | ForEach-Object { Write-Host "Need review: "$_  -ForegroundColor red}