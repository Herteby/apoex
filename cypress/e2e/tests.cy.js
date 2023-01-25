describe('ApoEx Beer Search', () => {
  beforeEach(() => {
    cy.visit('http://localhost:8000/')
  })
  
  it('can search for a beer', () => {
    cy.get('#searchForm input').type('Trashy Blonde')
    cy.get('#searchForm button').click()
    cy.get('.beerList').contains('Trashy Blonde')
    cy.get('.beerList').contains('4.1%')
  })
  
  it('shows beer details', () => {
    cy.get('#searchForm input').type('Trashy Blonde')
    cy.get('#searchForm button').click()
    cy.get('.beerList').contains('Trashy Blonde').click()
    cy.get('.details h1').contains('Trashy Blonde')
    cy.get('.details').contains('A titillating, neurotic, peroxide punk of a Pale Ale')
    cy.get('.details').contains('Pairs well with')
    cy.get('.details').contains('Fresh crab with lemon')
    cy.get('.details').contains('Garlic butter dipping sauce')
    cy.get('.details img')
  })
  
  it('shows message for no beers matching search', () => {
    cy.get('#searchForm input').type('qweqwe')
    cy.get('#searchForm button').click()
    cy.get('body').contains('Found no beers matching your search')
  })

  it('shows loading message', () => {
    cy.get('#searchForm input').type('qweqwe')
    cy.get('#searchForm button').click()
    cy.get('body').contains('Loading...')
  })
  
  it('can go to next page in search results', () => {
    cy.get('#searchForm input').type('a')
    cy.get('#searchForm button').click()
    cy.get('#nextPage').click()
    cy.get('#nextPage').click()
    cy.get('.beerList').contains('Sorachi Ace')
  })

  it('Shows loading next page message', () => {
    cy.get('#searchForm input').type('a')
    cy.get('#searchForm button').click()
    cy.get('#nextPage').click()
    cy.get('body').contains('Loading...')
  })
  
  it('can go to previous page', () => {
    cy.get('#searchForm input').type('a')
    cy.get('#searchForm button').click()
    cy.get('#nextPage').click()
    cy.get('#nextPage').click()
    cy.get('#prevPage').click()
    cy.get('.beerList').contains('Mixtape 8')
  })
  
  it('previous page button disabled on first page', () => {
    cy.get('#searchForm input').type('abc')
    cy.get('#searchForm button').click()
    cy.get('#prevPage[disabled]')
  })
  
  it('next page button disabled when less than 10 results', () => {
    cy.get('#searchForm input').type('abc')
    cy.get('#searchForm button').click()
    cy.get('#nextPage').click()
    cy.get('#nextPage').click()
    cy.get('#nextPage[disabled]')
  })

  it('shows no more beers matching your search message', () => {
    cy.get('#searchForm input').type('hello')
    cy.get('#searchForm button').click()
    cy.get('#nextPage').click()
    cy.get('#nextPage').click()
    cy.get('body').contains('Found no more beers matching your search')
  })
})