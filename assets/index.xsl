<?xml version="1.0"?>
<!--
 * SPDX-FileCopyrightText: Copyright (c) 2023 Yegor Bugayenko
 * SPDX-License-Identifier: MIT
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:strip-spaces select="*"/>
  <xsl:param name="version"/>
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>fief</title>
        <meta charset="UTF-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <link rel="icon" href="https://raw.githubusercontent.com/yegor256/fief/master/logo.svg" type="image/svg"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript">
          $(function() {
            $("#metrics").tablesorter({
              textExtraction: function(node) {
                var attr = $(node).attr('data-sort-value');
                if (typeof attr !== 'undefined' &amp;&amp; attr !== false) {
                  return attr;
                }
                return $(node).text();
              }
            });
          });
          $(function() {
            let params = (new URL(document.location)).searchParams;
            let org = params.get('org');
            if (org) {
              $('#metrics tbody tr:not(:has(&gt;td.org-' + org + '))').hide();
              $('#org').text('@' + org);
              $('#org-head').css('visibility', 'visible');
              console.log('Showing @' + org + ' org');
            }
          });
        </script>
        <style>
          td, th { font-family: monospace; font-size: 18px; line-height: 1em; }
          td.top { vertical-align: middle; }
          .num { text-align: right; }
          .left { border-bottom: 0; }
          section { width: auto; }
          header { text-align: center; }
          footer { text-align: center; font-size: 0.8em; line-height: 1.2em; color: gray; }
          article { border: 0; }
          .subtitle { font-size: 0.8em; line-height: 1em; color: gray; }
          .sorter { cursor: pointer; }
        </style>
      </head>
      <body>
        <section>
          <header>
            <p>
              <a href="">
                <img src="https://raw.githubusercontent.com/yegor256/fief/master/logo.svg" style="width:64px"/>
              </a>
            </p>
          </header>
          <article>
            <table id="metrics">
              <xsl:attribute name="data-sortlist">
                <xsl:text>[[</xsl:text>
                <xsl:for-each select="fief/titles/title">
                  <xsl:sort select="."/>
                  <xsl:value-of select="position() + 2"/>
                </xsl:for-each>
                <xsl:text>,1]]</xsl:text>
              </xsl:attribute>
              <colgroup>
                <col/>
                <xsl:for-each select="fief/titles/title">
                  <xsl:sort select="."/>
                  <col/>
                </xsl:for-each>
                <col/>
              </colgroup>
              <thead>
                <xsl:apply-templates select="fief/titles"/>
              </thead>
              <xsl:apply-templates select="fief/repositories"/>
              <tfoot>
                <tr>
                  <td>Total:</td>
                  <xsl:for-each select="fief/titles/title">
                    <xsl:variable name="title" select="."/>
                    <td class="num">
                      <xsl:value-of select="sum(//m[@id=$title])"/>
                    </td>
                  </xsl:for-each>
                </tr>
              </tfoot>
            </table>
          </article>
          <footer>
            <p>
              <xsl:for-each select="fief/titles/title[@subtitle]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="position() = 1">
                  <xsl:text> stands</xsl:text>
                </xsl:if>
                <xsl:text> for </xsl:text>
                <xsl:value-of select="@subtitle"/>
              </xsl:for-each>
              <xsl:text>.</xsl:text>
            </p>
            <p>
              <xsl:for-each select="fief/legend/column">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="@title"/>
                <xsl:text>" is </xsl:text>
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:text>.</xsl:text>
            </p>
            <p>
              <xsl:text>The page was generated by </xsl:text>
              <a href="https://github.com/yegor256/fief">
                <xsl:text>fief</xsl:text>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$version"/>
              </a>
              <xsl:text> on </xsl:text>
              <xsl:value-of select="fief/@time"/>
              <xsl:text>. </xsl:text>
              <br/>
              <xsl:text>It took </xsl:text>
              <xsl:variable name="sec" select="round(fief/@sec)"/>
              <xsl:choose>
                <xsl:when test="$sec &lt; 60">
                  <xsl:value-of select="$sec"/>
                  <xsl:text>s</xsl:text>
                </xsl:when>
                <xsl:when test="$sec &lt; 3600">
                  <xsl:value-of select="format-number($sec div 60, '#.##')"/>
                  <xsl:text>min</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="format-number($sec div 3600, '#.#')"/>
                  <xsl:text>h</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> to build the report.</xsl:text>
              <br/>
              <xsl:text>The XML with the data </xsl:text>
              <a href="index.xml">
                <xsl:text>is here</xsl:text>
              </a>
              <xsl:text>.</xsl:text>
            </p>
          </footer>
        </section>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="fief/titles">
    <tr>
      <th class="sorter">
        <xsl:text>Repository</xsl:text>
      </th>
      <xsl:for-each select="title">
        <xsl:sort select="."/>
        <th class="sorter num">
          <xsl:value-of select="."/>
        </th>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <xsl:template match="fief/repositories">
    <tbody>
      <xsl:apply-templates select="repository"/>
    </tbody>
  </xsl:template>
  <xsl:template match="repository">
    <tr>
      <td class="top">
        <a href="https://github.com/{@id}">
          <xsl:value-of select="@id"/>
        </a>
      </td>
      <xsl:for-each select="metrics/m">
        <xsl:sort select="@id"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <xsl:template match="m">
    <td>
      <xsl:attribute name="class">
        <xsl:text>num</xsl:text>
        <xsl:if test="@alert">
          <xsl:text> firebrick</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="data-sort-value">
        <xsl:copy-of select="."/>
      </xsl:attribute>
      <xsl:copy-of select="."/>
    </td>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
