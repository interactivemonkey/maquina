<script language="javascript">
function addBookmark() {ldelim}
    if (window.sidebar) {ldelim}
        window.sidebar.addPanel('{$kbarticle.title}', location.href,"");
    {rdelim} else if( document.all ) {ldelim}
        window.external.AddFavorite( location.href, '{$kbarticle.title}');
    {rdelim} else if( window.opera && window.print ) {ldelim}
        return true;
    {rdelim}
{rdelim}
</script>

<h2>{$kbarticle.title}</h2>

<table width="100%" border="0" cellpadding="0" cellspacing="10">
  <tr>
    <td width="80%" align="left" valign="top"> {$kbarticle.text} <br />
      <br />
      <form method="post" action="knowledgebase.php?action=displayarticle&amp;id={$kbarticle.id}&amp;useful=vote">
        <p> {if $kbarticle.voted} <strong>{$LANG.knowledgebaserating}</strong> {$kbarticle.useful} {$LANG.knowledgebaseratingtext} ({$kbarticle.votes} {$LANG.knowledgebasevotes})
          {else} <strong>{$LANG.knowledgebasehelpful}</strong>
          <select name="vote">
            <option value="yes">{$LANG.knowledgebaseyes}</option>
            <option value="no">{$LANG.knowledgebaseno}</option>
          </select>
          <input type="submit" value="{$LANG.knowledgebasevote}" />
          {/if} </p>
      </form></td>
    <td width="20%" align="center" valign="top"><p align="center"><img src="images/addtofavouritesicon.gif" class="absmiddle" border="0" alt="{$LANG.knowledgebasefavorites}" /> <a href="#" onclick="addBookmark();return false">{$LANG.knowledgebasefavorites}</a><br /><br />
        <img src="images/print.gif" class="absmiddle" border="0" alt="{$LANG.knowledgebaseprint}" /> <a href="#" onclick="window.print();return false">{$LANG.knowledgebaseprint}</a></p></td>
  </tr>
</table>
{if $kbarticles}
  <div class="kbalsoread">{$LANG.knowledgebasealsoread}</div>
  {foreach key=num item=kbarticle from=$kbarticles}
    <div class="kbarticle">
      <img src="images/article.gif" align="middle" alt="" /> <strong><a href="{if $seofriendlyurls}knowledgebase/{$kbarticle.id}/{$kbarticle.urlfriendlytitle}.html{else}knowledgebase.php?action=displayarticle&amp;id={$kbarticle.id}{/if}">{$kbarticle.title}</a></strong> <span class="kbviews">({$LANG.knowledgebaseviews}: {$kbarticle.views})</span>
    </div>
  {/foreach}
{/if}
<br />