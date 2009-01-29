// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function ToggleHeader()
{
    if( $("headster").style.display == 'block') 
    {
      $("headster").style.display = 'none';
    } 
    else
    {
      $("headster").style.display ='block';
    }
    if( $("headster2").style.display == 'block') 
    {
      $("headster2").style.display = 'none';
    } 
    else
    {
      $("headster2").style.display ='block';
    }
    if( $("footster").style.display == 'block') 
    {
      $("footster").style.display = 'none';
    } 
    else
    {
      $("footster").style.display ='block';
    }
}
