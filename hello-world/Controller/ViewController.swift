//
//  ViewController.swift
//  hello-world
//
//  Created by Taylor on 8/12/22.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate {
    
    private var colors = Colors()
    
    private var homeButton = UIBarButtonItem()
    private var registerToggleButton = UIBarButtonItem()
    
    private var pokemonDetailsView: PokemonDetailsView!
    private var pokemonGallaryView: PokemonGallaryView!

   

    private var titleLabel = UILabel()
    private var refreshButton = UIButton()
    private let screenSize: CGRect = UIScreen.main.bounds
    
    private var currentPokemonIndex =
    PokedexAPI.shared.getCurrentPokemonIndex()
    private var currentPokemonData: [PokemonData]?
    private var allPokemon = [Pokemon]()
    
    let gbFont = UIFont(name: "PokemonGB", size: UIFont.labelFontSize)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.init() {
            await PokedexAPI.shared.getPokemonFromAPI()
            PokedexAPI.shared.setDbtoPersistencyManager()
            allPokemon = PokedexAPI.shared.getPokemon()
            await PokedexAPI.shared.getImagesFromApi(pokemonArray: allPokemon)
            refreshAllPokemon()
        }
        
        // this feels redunant, but I dont want to wait for the async/await portions of the task if we already have data to display. At the same time, I want to make sure that I am sending the right requests for images to the pokemon API.
        
        PokedexAPI.shared.setDbtoPersistencyManager()
        allPokemon = PokedexAPI.shared.getPokemon()
        showDataForPokemon()
        
        
        titleLabel.text = "Pokedex"
        titleLabel.textAlignment = .center
        titleLabel.textColor = colors.heading
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = gbFont
        titleLabel.font = UIFontMetrics.default.scaledFont(for: gbFont!)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.backgroundColor = .magenta
        refreshButton.setTitle("Navigate", for: .normal)
        
        pokemonGallaryView = PokemonGallaryView(frame: CGRect(x: 0, y: 120, width: 2000, height: 150))
        pokemonDetailsView = PokemonDetailsView(frame: CGRect(x: 0, y: 280, width: (screenSize.width), height: 150), style: UITableView.Style.plain)
        
        pokemonDetailsView.register(DetailsCell.self, forCellReuseIdentifier: "cell")
        pokemonDetailsView.dataSource = self
        pokemonDetailsView.backgroundColor = colors.mainBackground
        view.addSubview(pokemonDetailsView)
        
        view.backgroundColor = colors.mainBackground
        
        
        pokemonGallaryView.backgroundColor = colors.gallaryBackground
        pokemonGallaryView.delegate = self
        
        
        view.addSubview(titleLabel)
        view.addSubview(refreshButton)
//        view.addSubview(plistButton)
        view.addSubview(pokemonGallaryView)
        
        pokemonGallaryView.contentSize = CGSize(width: 120 * (allPokemon.count + 1), height: 110)
        
        buildSlides()
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: pokemonDetailsView.bottomAnchor, constant: 60),
            
            pokemonGallaryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonGallaryView.widthAnchor.constraint(equalTo: view.widthAnchor),
            pokemonGallaryView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            pokemonGallaryView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 270),
        ])
        
        refreshButton.addTarget(self, action: #selector(navClick), for: .touchUpInside)

    }
    
    
    @objc func navClick(){
        let settings = SettingsViewController()
        self.present(settings, animated: true)
    }
    
    @objc func refreshAllPokemon(){
        allPokemon = PokedexAPI.shared.getPokemon()
        pokemonGallaryView.contentSize = CGSize(width: 120 * (allPokemon.count + 1), height: 110)
        buildSlides()
     }
    
    @objc func refreshDetails(){
        showDataForPokemon()
     }
   
    private func showDataForPokemon(){
        let index = PokedexAPI.shared.getCurrentPokemonIndex()
        if (index < allPokemon.count && index >= 0){
            currentPokemonData = allPokemon[index].tableRepresentation
        } else {
        currentPokemonData = nil
        }
    pokemonDetailsView?.reloadData()
    }
    
    func buildSlides(){
        allPokemon = PokedexAPI.shared.getPokemon()
        for pokemon in allPokemon {
            let index = allPokemon.firstIndex(where: {$0.id == pokemon.id}) ?? 1
            let nextSlide = PokemonSlide(frame: CGRect(x: (index+1)*120, y: 20, width: 110, height: 110))
            nextSlide.backgroundColor = colors.pokemonSlideBackground
            nextSlide.layer.cornerRadius = 55
            
            nextSlide.allButton.addTarget(self, action: #selector(refreshDetails), for: .touchUpInside)
            nextSlide.setTitle(string: pokemon.name)
            nextSlide.setImg(id: pokemon.id)
            nextSlide.setIndex(index: index)
            
            pokemonGallaryView.addSubview(nextSlide)
        }
    }
}


extension ViewController: UITableViewDataSource{
    
    class DetailsCell: UITableViewCell {
        private var colors = Colors()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            detailTextLabel?.textColor = colors.detailsValue
            textLabel?.textColor = colors.detailsName
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return currentPokemonData?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pokemonDetailsView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailsCell
        if let pokemonData = currentPokemonData {
            let row = indexPath.row
            
            cell.textLabel?.text = pokemonData[row].name
            cell.detailTextLabel?.text = pokemonData[row].value
            
//            cell.backgroundColor = .black
        }
        return cell
    }

    
}
