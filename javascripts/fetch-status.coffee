---
---

baseURL = "https://api.travis-ci.org/repos"

#
# Fills a string containing special templating syntax with the data provided.
#
# Ex:
#    tmpl = "${name} got a ${grade} in ${course}.";
#    data = { name: "John", grade: "B", course: "Plant Pathology" };
#    tmpl.template(data); // outputs "John got a B in Plant Pathology."
#
String.prototype.fill = (data) ->
    regex = null
    completed = @toString()
    for el, value of data
      break if completed.indexOf("$") < 0
      regex = new RegExp("\\${#{el}}", 'g')
      completed = completed.replace(regex, value)
    completed.toString()

makeXHRRequest = (url, callback) ->
  myRequest = new XMLHttpRequest()
  myRequest.onreadystatechange = extractData(callback)
  myRequest.open("get", url, true)
  myRequest.setRequestHeader("Accept", "application/vnd.travis-ci.2+json")
  myRequest.send()

extractData = (callback) ->
  return ->
    if @readyState == 4
      callback(JSON.parse(this.responseText))

fetchAndDisplayStatus = (repo) ->
  makeXHRRequest("#{baseURL}/#{repo.dataset.nwo}/branches/#{repo.dataset.branch}", changeColorToMatchStatus(repo.id))

fetchAndDisplayStatuses = ->
  repos = document.getElementsByClassName("repo")
  fetchAndDisplayStatus(repo) for repo in repos
  repos

changeColorToMatchStatus = (id) ->
  (data) ->
    console.log(data)
    repoEl = document.getElementById(id)
    repoEl.dataset.status = data.branch.state

document.onreadystatechange = ->
  fetchAndDisplayStatuses() if @readyState == "complete"
